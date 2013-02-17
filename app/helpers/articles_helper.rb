module ArticlesHelper
  def image_proxy_uri uri
    if uri.starts_with? 'http://img.cnbeta.com/'
      image_proxy_url uri: uri
    else
      uri
    end
  end
end
