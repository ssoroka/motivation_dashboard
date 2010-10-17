require 'hominid'

class Integration
  class CustomImage
    REPORT_TYPES = HashWithIndifferentAccess.new({ :custom_image => :image })

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
    end

    def perform
    end

    class DataSource
      def self.info
        {
          :description => "Have a widget display an image of your own by providing a url.",
          :fields => []
        }
      end

      def self.check_config(config)
        {}
      end
    end


    class DataSet
      def self.info(data_source_config)
        nil
      end

      # Checks that the config is valid and returns it with any necessary modifications, if invalid, returns errors
      def self.check_config(config)
        if config[:url].present?
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
            { :name => :report_type, :type => :select, :options => [['Custom Image', :custom_image]]},
            { :name => :url, :type => :string, :label => 'Image URL'}
          ]
        }
      end

      def self.check_config(config)
        config
      end

    end

  end
end
