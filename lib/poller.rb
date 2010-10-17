# require 'config/environment'
class Poller
  def poll
    loop do
      User.where(:next_poll_at => '<= NOW()').order('next_poll_at asc').limit(50).all{|user|
        debug("processing user #{user.id}..")
        user.punt_polling!
          
        user.data_sources.each{|data_source|
          poll_datasource(data_source)
        }
      }
      debug("loop..")
    end
  end
  
  def poll_datasource(data_source)
    klass_str = data_source.integration.to_s.camelcase
    klass = "Integration::#{klass_str}".constantize
    
    data_sources.each do |data_source|
      obj = nil
      data_source.data_sets.each do |data_set|
        data_set.reports.each do |report|
          obj ||= klass.new(data_source.config)
          report.update_attribute(:data, obj.perform(dataset.config, report.config))
        end
      end
    end
  end
  
  def debug(str)
    puts str
  end
end

# Poller.new.poll 