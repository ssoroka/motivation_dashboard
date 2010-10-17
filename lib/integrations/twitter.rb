require 'twitter'

class Integration
  class Twitter
    REPORT_TYPES = HashWithIndifferentAccess.new({ :search_table => :table })

    def initialize(options = {})
    end

    def perform(data_set_options, report_options)
      search_table(data_set_options[:query])
    end

    def search_table(query)
      results = ::Twitter::Search.new(query).fetch.results.map do |tweet|
        link = "http://twitter.com/#{tweet.from_user}/statuses/#{tweet.id}"
        { 'row' => [%Q(<a href="#{link}">#{tweet.text}</a>)] }
      end

      {
        'label' => "Tweets about #{query}",
        'headers' => [''],
        'rows' => results
      }
    end

    class DataSource
      def self.info
        {
          :description => "Display tweets about a topic.",
          :fields => []
        }
      end

      def self.check_config(config)
        {}
      end
    end


    class DataSet
      def self.info(data_source_config)
        {
          :fields => [
            { :name => :query, :type => :string, :label => 'Search Term' }
          ]
        }
      end

      # Checks that the config is valid and returns it with any necessary modifications, if invalid, returns errors
      def self.check_config(config)
        if config[:query].present?
          config
        else
          false
        end
      end
    end

    class Report

      def self.info
        {
          :fields => [
            { :name => :report_type, :type => :select, :options => [['Twitter Search', :search_table]]},
          ]
        }
      end

      def self.check_config(config)
        config
      end

    end

  end
end
