class DataSource < ActiveRecord::Base
  belongs_to :user
  has_many :data_sets
  
  before_create :set_api_key
  validates_presence_of :integration_id


  def set_api_key
    self.api_key = SecureRandom.hex(20)
  end
  
  def config=(opts)
    write_attribute(:config, opts.to_yaml)
  end

  def config
    YAML::load(read_attribute(:config))
  end
  
  def integration
    Integration::INTEGRATIONS.invert[data_set.integration_id]
  end
  
  def integration=(key)
    self.integration_id = Integration::INTEGRATIONS[key.to_sym]
  end
  
end
