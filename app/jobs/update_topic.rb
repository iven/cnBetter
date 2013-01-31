# coding: utf-8

require 'open-uri'

module UpdateTopic
  @queue = :update_topic

  @re_article = %r{<a href="/topics/\d+.htm" ><img src="(?<image_url>[^"]+?)" alt="(?<name>[^"]+?)"}

  def self.perform(article_id)
    uri = "http://cnbeta.com/articles/#{article_id}.htm"

    md = open(uri).read.force_encoding('gb18030').match(@re_article)
    if md
      hash = Hash[ md.names.zip(md.captures) ]
      unless Topic.where(name: md['name']).exists?
        Topic.create!(hash)

        unless Image.where(uri: md['image_url']).exists?
          Resque.enqueue(UpdateImage, md['image_url'])
        end
      end
    end
  end
end


