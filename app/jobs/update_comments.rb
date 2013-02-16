# coding: utf-8

require 'open-uri'
require 'nokogiri'

module UpdateComments
  @queue = :update_comments

  def self.perform
    recent_articles = Article.where(:published_on.gt => 1.day.ago)

    recent_articles.each do |article|
      uri = "http://www.cnbeta.com/comment/g_content/#{article.id}.html"
      doc = Nokogiri::HTML(open(uri).read.force_encoding('utf-8'))
      doc.css('dl').each do |dl|
        author, time = dl.css('.re_author span').first.text.strip.split(' 发表于 ')
        content = dl.css('.re_detail').first.inner_html.strip.gsub("\n", "<br>")
        support, against = dl.css('.re_mark_right span').map{ |span| Integer(span.text) }
        id_ = Integer(dl.css('div').last['id'].split('h').last)
        comment = article.comments.find_or_create_by(id_: id_)
        comment.update_attributes({
          author:  author,
          content: content,
          support: support,
          against: against,
          time:    time
        })
      end
      unless article.comments.empty?
        article.update_attributes(updated_on: Time.now)
      end
    end
  end
end


