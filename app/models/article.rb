class Article
  include Mongoid::Document
  field :id_, type: Integer
  field :title, type: String
  field :author, type: String
  field :content, type: String
  field :published_on, type: DateTime
  field :updated_on, type: DateTime
  field :_id, type: Integer, default: ->{ id_ }

  embeds_many :comments
  has_many :images
  belongs_to :topic

  default_scope desc(:published_on)
  paginates_per 10
end
