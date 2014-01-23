require 'open-uri'
require 'oj'
require 'active_support/time'

task update_comments: :environment do |t, args|
  recent_articles = Article.all(:created_at.gt => Integer(ENV['time']).hour.ago)

  recent_articles.each do |article|
    comments_length_orig = article.comments.length

    uri = "http://m.cnbeta.com/wap/hotcomments.htm?id=#{article.id}"
    doc = Nokogiri::HTML(open(uri).read.force_encoding('utf-8'))
    comments = doc.css('div.content div')

    if comments.length >= 3
      article.comments.all.destroy

      comments.each_slice(3) do |hot_comment|
        Comment.create(
          author: '',
          region: '',
          content: hot_comment[2].children[0].text.strip,
          support: 0,
          against: 0,
          posted_at: Time.now,
          article: article,
        )
        if comments_length_orig < 3 and comments.length >= 3 * 3
          article.hot_at = Time.now
        end
        article.updated_at = Time.now
        article.save!
      end
    end
  end
end

