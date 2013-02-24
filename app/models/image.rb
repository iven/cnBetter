class Image
  include Mongoid::Document
  field :uri, type: String, default: ''
  field :data, type: Moped::BSON::Binary
  field :time, type: DateTime, default: ->{ Time.now }
  field :_id, type: String, default: ->{ uri }

  belongs_to :article
  belongs_to :topic
end
