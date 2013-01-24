class Comment
  include Mongoid::Document
  field :id, type: Integer
  field :content, type: String
  field :support, type: Integer
  field :against, type: Integer
  embedded_in :article, inverse_of: :comments
end
