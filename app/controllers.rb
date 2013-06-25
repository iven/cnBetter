CnBetter::App.controllers  do
  get :feed, :map => '/feed', provides: [:atom] do
    @articles = Article.all(order: [:created_at.desc], limit: 20)
    render 'feed'
  end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  

end
