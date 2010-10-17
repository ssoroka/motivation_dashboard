class DataSet < ActiveRecord::Base
  belongs_to :data_source
  has_many :reports
  
  def config=(opts)
    write_attribute(:config, HashWithIndifferentAccess.new(opts).to_yaml)
  end

  def config
    if c = read_attribute(:config)
      YAML::load(c)
    end
  end
end
