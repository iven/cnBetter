# coding: utf-8
#
require 'open-uri'
require 'uri'

module UpdateImage
  @queue = :update_image

  def self.perform(uri)
    return if Image.where(uri: uri).exists?

    image_data = open(URI.escape(uri)).read

    Image.create!({ uri: uri, data: Moped::BSON::Binary.new(:generic, image_data) })
  end
end


