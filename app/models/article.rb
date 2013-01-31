class Article
  include Mongoid::Document
  field :id_, type: Integer
  field :title, type: String
  field :author, type: String
  field :content, type: String
  field :published_on, type: DateTime
  field :_id, type: Integer, default: ->{ id_ }
  embeds_many :comments
  belongs_to :topic
end
