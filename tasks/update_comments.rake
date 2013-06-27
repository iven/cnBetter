require 'open-uri'
require 'oj'
require 'active_support/time'

task update_comments: :environment do |t, args|
  recent_articles = Article.all(:created_at.gt => Integer(ENV['time']).hour.ago)

  recent_articles.each do |article|
    comments_length_orig = article.comments.length

    uri = "http://www.cnbeta.com/comment.htm?op=info&page=1&sid=#{article.id}"
    doc = Oj.load(open(uri).read.force_encoding('utf-8'))
    comments = doc['result']['hotlist']
    comments.each do |hot_comment|
      dict = doc['result']['cmntstore'][hot_comment['tid']]
      id = dict['tid']
      comment = Comment.first_or_create(id: id)
      comment.attributes = {
        author: dict['name'],
        region: dict['host_name'],
        content: dict['comment'],
        support: dict['score'],
        against: dict['reason'],
        posted_at: dict['date'],
        article: article,
      }
      comment.save!
      if comments_length_orig < 3 and comments.length >= 3
        article.hot_at = Time.now
      end
      article.updated_at = Time.now
      article.save!
    end
  end
end

