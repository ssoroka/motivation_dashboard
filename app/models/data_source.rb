class DataSource < ActiveRecord::Base
  belongs_to :user
  has_many :data_sets
  
  before_create :set_api_key

  def set_api_key
    self.api_key = SecureRandom.hex(20)
  end
  
end
