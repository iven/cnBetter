class Article
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Integer, key: true
  property :title, String
  property :content, Text
  property :created_at, DateTime
  property :updated_at, DateTime
  property :hot_at, DateTime

  has n, :comments
end
