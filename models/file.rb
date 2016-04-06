require 'dm-core'

class UploadFile
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String, :required => true
  property :short_name,   String, :required => true
  property :created_at,   DateTime
  property :views,        Integer, :default => 0

  belongs_to :user
end