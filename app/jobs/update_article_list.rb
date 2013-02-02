# coding: utf-8

require 'open-uri'
require 'nokogiri'

module UpdateArticleList
  @queue = :update_article_list

  def self.perform
    doc = Nokogiri::XML(open('http://m.cnbeta.com/'))

    doc.css('a')[3..32].each do |a|
      id = a['href'].split('=')[1]
      unless Article.where(id_: id).exists?
        Resque.enqueue(UpdateArticle, id)
      end
    end
  end
end

