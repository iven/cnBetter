# coding: utf-8

require 'open-uri'
require 'nokogiri'

module UpdateArticleList
  @queue = :update_article_list

  def self.perform
    ids = []
    doc = Nokogiri::XML(open('http://m.cnbeta.com/'))

    # get ID list
    doc.css('a')[3..32].each do |a|
      ids << a['href'].split('=')[1]
    end

    ids.reject! { |id| Article.where(id_: id).exists? }

    ids.each do |id|
      Resque.enqueue(UpdateArticle, id)
    end
  end
end

