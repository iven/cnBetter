# coding: utf-8
#
require 'open-uri'
require 'nokogiri'

module UpdateArticle
  @queue = :update_article
  @re_article = %r{<b>(?<title>.*)</b><br/><b>新闻发布日期：</b>(?<published_on>.*)<br/><b>新闻主题：</b> (?<topic>.*) <br/><br/> (<b>感谢(?<author>.*?)的投递</b><br />)?(?<content>.*)<a href="hcomment}m

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

    md = open(uri).read.force_encoding('utf-8').match(@re_article)
    if md
      hash = Hash[ md.names.zip(md.captures) ]

      doc = Nokogiri::HTML(hash['content'])
      self.format_image! doc

      hash['content'] = doc.to_html
      hash['id_'] = Integer(id)

      Article.create!(hash)

      unless Topic.where(name: md['topic']).exists?
        Resque.enqueue(UpdateTopic, hash['id_'])
      end
    end
  end
end

