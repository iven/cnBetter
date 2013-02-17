class Comment
  include Mongoid::Document
  field :id_, type: Integer
  field :author, type: String
  field :content, type: String
  field :support, type: Integer
  field :against, type: Integer
  field :time, type: DateTime
  field :_id, type: Integer, default: ->{ id_ }

  embedded_in :article

  default_scope desc(:support)
end
