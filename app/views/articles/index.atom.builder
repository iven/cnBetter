atom_feed do |feed|
  feed.title "cnBetter - cnBeta 全文版"

  latest_article = @articles.first
  feed.updated(latest_article && latest_article.published_on)

  @articles.each do |article|
    feed.entry(article) do |entry|
      entry.title article.title
      entry.updated article.updated_on
      entry.author do |author|
        author.name article.author
      end

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
      content << article.content.html_safe
      entry.content content, type: :html
    end
  end
end
