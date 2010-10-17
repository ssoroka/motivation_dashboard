require 'json'

class Integration
  class Github
  
    # Some fun test data 
    #
    # params = {}
    # params[:payload] = '{
    #   "after": "0d47df37b40bbf6c2172e83596c0334390d0c558", 
    #   "before": "83814b06b9d403f3f9e43589ee137c3cac44d182", 
    #   "commits": [
    #     {
    #       "added": [],
    #       "author": {
    #         "email": "jonathan@titanous.com", 
    #         "name": "Jonathan Rudenberg"
    #       }, 
    #       "id": "0d47df37b40bbf6c2172e83596c0334390d0c558", 
    #       "message": "Make Gmail integration even more awesome", 
    #       "modified": [
    #         "lib\/integrations\/gmail.rb"
    #       ], 
    #       "removed": [], 
    #       "timestamp": "2010-10-16T06:03:42-07:00", 
    #       "url": "https:\/\/github.com\/railsrumble\/rr10-team-232\/commit\/0d47df37b40bbf6c2172e83596c0334390d0c558"
    #     }
    #   ], 
    #   "compare": "https:\/\/github.com\/railsrumble\/rr10-team-232\/compare\/83814b0...0d47df3", 
    #   "forced": false, 
    #   "pusher": {
    #     "email": "jonathan@titanous.com", 
    #     "name": "titanous"
    #   }, 
    #   "ref": "refs\/heads\/master", 
    #   "repository": {
    #     "created_at": "2010\/10\/15 10:36:58 -0700", 
    #     "description": "Repository for the RailsRumble 2010 Team 232", 
    #     "fork": false, 
    #     "forks": 0, 
    #     "has_downloads": true, 
    #     "has_issues": true, 
    #     "has_wiki": true, 
    #     "name": "rr10-team-232", 
    #     "open_issues": 0, 
    #     "owner": {
    #       "email": "organizers@railsrumble.com", 
    #       "name": "railsrumble"
    #     }, 
    #     "private": true, 
    #     "pushed_at": "2010\/10\/16 06:03:44 -0700", 
    #     "url": "https:\/\/github.com\/railsrumble\/rr10-team-232", 
    #     "watchers": 1
    #   }
    # }'
  
    def initialize(params)
      @payload = JSON.parse(params[:payload])
    end
  
    def parsed
      @payload['commits'].each do |commit|
        [commit['author']['name'], commit['author']['message'], commit['author']['timestamp']]
      end
    end
    
    class DataSource
      def self.info
        {
          :description => 'Set up a hook on your repository to motivationaldashboard.com/integrations/github/post_receive_hook',
          :fields => []
        }
      end
    
      # Checks that the config is valid and returns it with any necessary modifications, if invalid, returns errors
      def self.check_config(config)
        begin
          config
        rescue Exception => e
          false
        end
      end
    end
    
    
    class DataSet
      def self.info(data_source_config)
        nil
      end
      
      # Checks that the config is valid and returns it with any necessary modifications, if invalid, returns errors
      def self.check_config(config)
        config
      end
    end
    
    class Report
      
      def self.info
        {
          :fields => [
            { :name => :report_type, :type => :select, :options => [['Commit History', REPORT_TYPES[:commits]]] }
          ]
        }
      end
      
      def self.check_config(config)
        config
      end
      
    end
    
  end
end