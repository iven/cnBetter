# coding: utf-8

require 'open-uri'

module UpdateTopic
  @queue = :update_topic

  @re_article = %r{<a href="/topics/\d+.htm" ><img src="(?<image_uri>[^"]+?)" alt="(?<name>[^"]+?)"}

  def self.perform(article_id)
    uri = "http://cnbeta.com/articles/#{article_id}.htm"

    md = open(uri).read.force_encoding('gb18030').encode!('utf-8').match(@re_article)
    if md
      Topic.find_by(name: md['name']) do |topic|
        image_uri = md['image_uri']
        unless topic.image_uri
          topic.update_attributes!(image_uri: image_uri)

          image = Image.find_or_create_by(uri: uri)
          unless image.data
            Resque.enqueue(UpdateImage, image_uri)
          end
        end
      end
    end
  end
end


