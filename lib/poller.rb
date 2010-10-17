require 'config/environment'
require 'lib/faye_client'
class Poller
  TIMESTAMP_FORMAT = '%h %d %H:%M:%S'
  
  def poll_loop
    debug('Started poller')
    loop do
      User.where('next_poll_at <= ?', Time.now.utc.to_s(:db)).order('next_poll_at asc').limit(50).each{|user|
        debug("processing user #{user.id}..")
        user.punt_polling!
          
        user.data_sources.each{|data_source|
          poll_datasource(user, data_source)
        }
      }
      sleep 0.5
    end
  end
  
  def poll_all
    User.find_each{|user|
      debug("processing user #{user.id}..")
        
      user.data_sources.each{|data_source|
        poll_datasource(data_source)
      }
    }
  end
  
  def poll_datasource(user, data_source)
    debug("  fetching data source #{data_source.id} #{data_source.integration}..")
    klass_str = data_source.integration.to_s.camelcase
    klass = "Integration::#{klass_str}".constantize
    
    obj = nil
    data_source.data_sets.each do |data_set|
      data_set.reports.each do |report|
        obj ||= klass.new(data_source.config)
        if report.widgets.any?
          data = obj.perform(data_set.config, report.config)

          report.update_attribute(:data, data)

          report.widgets.each{|widget|
            client.publish("/users/#{user.api_key}/widgets", widget.as_json({}))
          }
        end
      end
    end
  end
  
  def debug(str)
    puts "[#{Time.now.strftime(TIMESTAMP_FORMAT)}] #{str}"
    # client.publish('/debug', {'text' => str}) if Rails.env.development?
  end
  
  def client
    @client ||= FayeClient.instance
  end
end

Poller.new.poll_loop
