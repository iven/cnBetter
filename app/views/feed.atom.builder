xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   "cnBetter"
  xml.link    "rel" => "self", "href" => url_for(:feed)
  xml.id      url_for(:feed)
  xml.updated @articles.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" unless @articles.empty?
  xml.author  { xml.name "Iven Hsu" }

  @articles.each do |article|
    xml.entry do
      xml.title   article.title
      xml.link    "rel" => "alternate", "href" => "http://www.cnbeta.com/articles/#{article.id}.htm"
      xml.id       "http://www.cnbeta.com/articles/#{article.id}.htm"
      xml.published article.created_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.updated article.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name 'ivenvd@gmail.com' }
      content = ''
      article.comments.all(order: [:support.desc]).each do |comment|
        content << "* #{comment.content}<br />"
      end
      content << article.content
      xml.content content, type: :html
    end
  end
end

