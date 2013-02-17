class Topic
  include Mongoid::Document
  field :name, type: String
  field :image_url, type: String

  has_many :articles
end
