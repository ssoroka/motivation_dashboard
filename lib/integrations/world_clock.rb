class Integration
  class WorldClock
    REPORT_TYPES = HashWithIndifferentAccess.new({ :world_clock => :world_clock })

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
    end

    def perform(data_set_config, report_config)
      {}
    end

    class DataSource
      def self.info
        {
          :description => "",
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

      def self.check_config(config)
        if config[:time_zone].present?
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
            { :name => :report_type, :type => :hidden, :value => :world_clock},
            { :name => :timezone_utc, :type => :timezone_select, :label => 'Time Zone'},
            { :name => :clock_name, :type => :string, :string => 'Clock Name'}
          ]
        }
      end

      def self.check_config(config)
        config
      end

    end

  end
end
