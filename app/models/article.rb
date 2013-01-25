class Article
  include Mongoid::Document
  field :id, type: Integer
  field :title, type: String
  field :author, type: String
  field :content, type: String
  field :published_on, type: DateTime
  field :_id, type: Integer, default: ->{ id }
  validates_presence_of :id
  embeds_many :comments
end
