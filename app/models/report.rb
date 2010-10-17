require 'yaml'
class Report < ActiveRecord::Base
  has_many :widgets
  belongs_to :data_set
  
  def config=(opts)
    write_attribute(:config, HashWithIndifferentAccess.new(opts).to_yaml)
  end

  def config
    if c = read_attribute(:config)
      YAML::load(c)
    end
  end
  
  def data=(opts)
    write_attribute(:data, HashWithIndifferentAccess.new(opts).to_yaml)
  end

  def data
    if d = read_attribute(:data)
      YAML::load(d)
    end
  end
end
