xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   "cnBetter"
  xml.link    "rel" => "self", "href" => url_for(:feed)
  xml.id      url_for(:feed)
  xml.updated @articles[0].updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @articles
  xml.author  { xml.name "Iven Hsu" }

  @articles.each do |article|
    xml.entry do
      xml.title   article.title
      xml.link    "rel" => "alternate", "href" => "http://www.cnbeta.com/articles/#{article.id}.htm"
      xml.id       "http://www.cnbeta.com/articles/#{article.id}.htm"
      xml.updated article.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name 'ivenvd@gmail.com' }
      content = ''
      article.comments.each do |comment|
        content << "
        <dl>
          <dt><small><strong>
            ↑#{comment.support}
            ↓#{comment.against}
          </strong></small></dt>
          <dd>#{comment.content}</dd>
        </dl>"
      end
      content << article.content
      xml.content content, type: :html
    end
  end
end

