require 'open-uri'

class ImageController < ApplicationController
  def proxy
    content_type = {
      'jpg'  => 'image/jpeg',
      'jpeg' => 'image/jpeg',
      'png'  => 'image/png',
      'gif'  => 'image/gif'
    }
    uri = params['uri']
    ext = uri.split('.')[-1]
    image = Image.find_by(uri: uri)
    send_data(image.data, type: content_type[ext], disposition: 'inline')
  end
end
