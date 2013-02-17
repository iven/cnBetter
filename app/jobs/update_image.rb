# coding: utf-8
#
require 'open-uri'
require 'uri'

module UpdateImage
  @queue = :update_image

  def self.perform(uri)
    return unless uri.start_with?('http://img.cnbeta.com/')

    image_data = open(URI.escape(uri)).read

    Image.find_by(uri: uri).update_attributes(
      data: Moped::BSON::Binary.new(:generic, image_data)
    )
  end
end


