class Report < ActiveRecord::Base
  has_many :widgets
  belongs_to :data_set
  
  def config=(opts)
    write_attribute(:config, HashWithIndifferentAccess.new(opts).to_yaml)
  end

  def config
    YAML::load(read_attribute(:config))
  end
end
