require 'dm-core'
require 'dm-types'

class Role
  include DataMapper::Resource

  property :id,           Serial
  property :max_size,     Integer,  :min => 0, :max => 2**63 - 1, :default => 5 * 1024 * 1024
  property :quota,        Integer,  :min => 0, :max => 2**63 - 1, :default => 0

  has n, :users
end

class User
  include DataMapper::Resource

  property :id,           Serial
  property :api,          String,   :length => 32, :unique => true, :default => ->(r, b) { SecureRandom.hex.upcase }
  property :email,        String
  property :password,     BCryptHash
  property :disk_used,    Integer,  :min => 0, :max => 2**63 - 1, :default => 0

  belongs_to :role
  has n, :files, 'UploadFile'

  def hist
    files.all(:limit => 5, :order => [ :created_at.desc ])
  end
end