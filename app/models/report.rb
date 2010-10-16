class Report < ActiveRecord::Base
  has_many :widget
  belongs_to :data_set
  
  def config=(opts)
    write_attribute(:config, opts.to_yaml)
  end

  def config
    YAML::load(read_attribute(:config))
  end
end
