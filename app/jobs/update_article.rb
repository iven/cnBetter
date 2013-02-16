# coding: utf-8
#
require 'open-uri'
require 'nokogiri'

module UpdateArticle
  @queue = :update_article
  @root_url = Rails.application.routes.url_helpers.root_url

  def self.format_paragraph
    @doc.css('br').each do |node|
      content = ""
      sibling = node.previous_sibling
      while sibling and ['a', 'b', 'i', 'text'].include?(sibling.name)
        content = sibling.to_html.strip + content
        sibling.remove
        sibling = node.previous_sibling
      end

      unless content.empty?
        node.replace(Nokogiri.make("<p>#{content}</p>"))
      end

      node.remove
    end
    @doc.xpath('//p/text() | //b/text()').each do |node|
      node.content = node.content.gsub('　', '')
    end
  end

  def self.format_video
    @doc.css('embed').wrap '<div class="ten columns centered flex-video"></div>'
  end

  def self.format_image
    @doc.css('a').each do |link|
      uri = link['href'].sub(%r{^img}, 'http://cnbeta.com/img')
      link['href'] = uri.sub(%r{^(http://img\.cnbeta\.com/)}, "#{@root_url}image/proxy?uri=\\1")
    end
    @doc.css('img').each do |img|
      uri = img['src'].sub(%r{^img}, 'http://cnbeta.com/img')
      unless Image.where(uri: uri).exists?
        Resque.enqueue(UpdateImage, uri)
      end
      img['src'] = uri.sub(%r{^(http://img\.cnbeta\.com/)}, "#{@root_url}image/proxy?uri=\\1")
    end
    @doc.css('img').wrap '<div align="center"></div>'
  end

  def self.perform(id)
    return if Article.where(id_: id).exists?

    uri = "http://m.cnbeta.com/marticle.php?sid=#{id}"

    @doc = Nokogiri::XML(open(uri).read.force_encoding('utf-8'))
    self.format_image
    self.format_video
    self.format_paragraph

    card = @doc.at_xpath('/wml/card/p')
    card.name = 'div'
    card['id'] = 'content'

    card.children[-3..-1].remove # 查看评论、返回首页
    card.child.remove # 返回首页
    title = card.child.remove.text.strip
    card.child.child.remove # 新闻发布日期
    published_on = Time.parse card.child.remove.text.strip
    card.child.child.remove # 新闻主题
    topic = card.child.remove.text.strip

    author = nil
    md = card.child.text.match(/感谢(?<author>.*)的投递/)
    if md
      author = md['author'].strip
      card.child.remove
    end

    article = Article.create!(
      id_: id,
      title: title,
      author: author,
      content: card.to_html,
      published_on: published_on,
      updated_on: published_on,
    )

    topic = Topic.find_or_create_by(name: topic)
    topic.articles << article
    unless topic.image_url
      Resque.enqueue(UpdateTopic, id)
    end
  end
end

