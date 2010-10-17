require 'hominid'

class Integration
  class MailChimp
    REPORT_TYPES = HashWithIndifferentAccess.new({ :campaign_stats => :table })

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
      @hominid = Hominid::Base.new(:api_key => options[:api_key])
    end

    def perform(*args)
      campaign_stats
    end

    def campaign_stats
      rows = @hominid.campaigns.map do |campaign|
        list = @hominid.find_list_by_id(campaign["list_id"])
        [campaign["subject"], campaign["from_email"], list["name"], list["member_count"], list["unsubscribe_count_since_send"]]
      end
    end

    class DataSource
      def self.info
        {
          :description => 'MailChimp',
          :fields => [
            { :name => :api_key, :type => :string, :helper_text => 'Enter your MailChimp API Key.' }
          ]
        }
      end

      # Checks that the config is valid and returns it with any necessary modifications, if invalid, returns errors
      def self.check_config(config)
        begin
          Integration::MailChimp.new({:api_key => config[:api_key]})
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
            { :name => :report_type, :type => :select, :options => [['Campaign Statistics', :campaign_stats]] }
          ]
        }
      end

      def self.check_config(config)
        config
      end

    end

  end
end
