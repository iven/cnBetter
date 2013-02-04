# coding: utf-8
#
require 'open-uri'
require 'nokogiri'

module UpdateArticle
  @queue = :update_article

  def self.format_paragraph!(doc)
    doc.search("//br/preceding-sibling::text()|//br/following-sibling::text()").each do |node|
      content = node.to_html.strip.gsub('　', '')
      unless content.empty?
        node.replace(Nokogiri.make("<p>#{content}</p>"))
      end
    end
    doc.css('br').remove
  end

  def self.format_image!(doc)
    doc.css('img').each do |img|
      uri = img['src'].sub(%r{^img}, 'http://cnbeta.com/img')
      unless Image.where(uri: uri).exists?
        Resque.enqueue(UpdateImage, uri)
      end
      img['src'] = uri.sub(%r{^(http://img\.cnbeta\.com/)}, '/image/proxy?uri=\1')
    end
  end

  def self.perform(id)
    return if Article.where(id_: id).exists?

    uri = "http://m.cnbeta.com/marticle.php?sid=#{id}"

    doc = Nokogiri::XML(open(uri).read.force_encoding('utf-8'))
    self.format_image! doc
    self.format_paragraph! doc

    card = doc.at_xpath('/wml/card/p')
    card.name = 'div'
    card['class'] = 'content'

    card.children[-3..-1].remove # 查看评论、返回首页
    card.child.remove # 返回首页
    title = card.child.remove.text.strip
    card.child.remove # 新闻发布日期
    published_on = card.child.remove.text.strip
    card.child.remove # 新闻主题
    topic = card.child.remove.text.strip
    card.child.remove # 空

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
    )

    topic = Topic.find_or_create_by(name: topic)
    topic.articles << article
    unless topic.image_url
      Resque.enqueue(UpdateTopic, id)
    end
  end
end

