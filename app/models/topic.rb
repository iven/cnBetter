class Topic
  include Mongoid::Document
  field :name, type: String

  has_one :image
  has_many :articles
end
