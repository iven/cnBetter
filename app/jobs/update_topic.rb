# coding: utf-8

require 'open-uri'

module UpdateTopic
  @queue = :update_topic

  @re_article = %r{<a href="/topics/\d+.htm" ><img src="(?<image_url>[^"]+?)" alt="(?<name>[^"]+?)"}

  def self.perform(article_id)
    uri = "http://cnbeta.com/articles/#{article_id}.htm"

    md = open(uri).read.force_encoding('gb18030').encode!('utf-8').match(@re_article)
    if md
      Topic.find_by(name: md['name']) do |topic|
        image_url = md['image_url']
        unless topic.image_url
          topic.update_attributes!(image_url: image_url)

          unless Image.where(uri: image_url).exists?
            Resque.enqueue(UpdateImage, image_url)
          end
        end
      end
    end
  end
end


