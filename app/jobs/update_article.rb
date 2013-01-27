# coding: utf-8
#
require 'open-uri'

module UpdateArticle
  @queue = :update_article
  @re_article = %r{<b>(?<title>.*)</b><br/><b>新闻发布日期：</b>(?<published_on>.*)<br/><b>新闻主题：</b> (?<topic>.*) <br/><br/> (<b>感谢(?<author>.*?)的投递</b><br />)?(?<content>.*)<a href="hcomment}m

  def self.perform(id)
    return if Article.where(id: id).exists?

    uri = "http://m.cnbeta.com/marticle.php?sid=#{id}"
    doc = open(uri).read.force_encoding('utf-8')

    md = doc.match(@re_article)
    hash = Hash[ md.names.zip(md.captures) ]
    hash['id_'] = Integer(id)

    article = Article.new(hash)
    article.save!
  end
end

