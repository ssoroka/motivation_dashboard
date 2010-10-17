require 'config/environment'
class Poller
  def poll
    loop do
      # User.where('next_poll_at <= ?', Time.now.utc.to_s(:db))
      User.order('next_poll_at asc').limit(50).each{|user|
        debug("processing user #{user.id}..")
        # user.punt_polling!
          
        user.data_sources.each{|data_source|
          poll_datasource(data_source)
        }
      }
      debug("loop..")
      sleep 0.2
      break
    end
  end
  
  def poll_datasource(data_source)
    klass_str = data_source.integration.to_s.camelcase
    klass = "Integration::#{klass_str}".constantize
    
    obj = nil
    data_source.data_sets.each do |data_set|
      data_set.reports.each do |report|
        obj ||= klass.new(data_source.config)
        report.update_attribute(:data, obj.perform(data_set.config, report.config))
      end
    end
  end
  
  def debug(str)
    puts str
  end
end

Poller.new.poll 