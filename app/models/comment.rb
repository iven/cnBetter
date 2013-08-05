class Comment
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :author, String
  property :title, Text
  property :region, Text
  property :content, Text
  property :support, Integer
  property :against, Integer
  property :posted_at, DateTime

  belongs_to :article
end
