require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "Article Model" do
  it 'can construct a new instance' do
    @article = Article.new
    refute_nil @article
  end
end
