require 'garb'
require 'active_support/time'
require 'gdata_google_analytics'

class Integration
  class GoogleAnalytics

    attr_reader :profile
  
    REPORT_TYPES = {:visitors => 1, :visits => 2, :pageviews => 3, :unique_pageviews => 4, :goal_completions => 5}

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
      Garb::Session.auth_sub options[:authsub_token]
    end

    def perform(data_set_config, report_config)
      @profile = Garb::Profile.first(data_set_config[:property_id])
      metric_by_day(REPORT_TYPES.invert[report_config[:report_type]])
    end


    def goal_conversions_by_day(goal_id)
      metric_by_day("goal#{goal_id}_completions".to_sym)
    end

    # view_type can be one of [:visitors, :visits, :pageviews, :unique_pageviews,
    #   :goal1_completions, etc]
    def metric_by_day(metric)
      { :month_to_date => month_to_date(metric), :last_month => last_month(metric) }
    end

    def month_to_date(metric)
      report = Garb::Report.new(@profile,
                                :start_date => Date.today.beginning_of_month,
                                :end_date => Date.today,
                                :dimensions => [:date],
                                :metrics => [metric])
      compile_report_to_day_array(report, metric)
    end

    def last_month(metric)
      report = Garb::Report.new(@profile,
                                :start_date => Date.today.beginning_of_month - 1.month,
                                :end_date => Date.today.beginning_of_month - 1.day,
                                :dimensions => [:date],
                                :metrics => [metric])
      compile_report_to_day_array(report, metric)
    end

    def compile_report_to_day_array(report, metric)
      report.results.map { |day| day.send(metric) }
    end
    
    class DataSource
      def self.info
        {
          :description => 'Google Analytics',
          :fields => [
            { 
              :url => lambda { |url| GData::Client::Analytics.new.authsub_url(url) }, 
              :url_text => 'Authorize Your Google Analytics Account', :type => :authsub
            }
          ]
        }
      end
    
      # Checks that the config is valid and returns it with any necessary modifications, if invalid, returns errors
      def self.check_config(config)
        begin
          config[:authsub_token] = GData::Client::Analytics.new(:authsub_token => config[:authsub_token]).auth_handler.upgrade
          config
        rescue Exception => e
          false
        end
      end
    end
    
    
    class DataSet
      def self.info(data_source_config)
        Garb::Session.auth_sub data_source_config[:authsub_token]
        profiles = Garb::Profile.all
        options = profiles.map { |p| [p.title, p.web_property_id]}
        {
          :description => 'Choose the Site to Show',
          :fields => [
            { :name => :property_id, :type => :select, :options => options }
          ]
        }
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
            { :name => :report_type, :type => :select, :options => [
                                                                      ['Visitors', REPORT_TYPES[:visitors]],
                                                                      ['Visit Amount', REPORT_TYPES[:visits]],
                                                                      ['Hits', REPORT_TYPES[:page_views]],
                                                                      ['Unique Hits', REPORT_TYPES[:unique_pageviews]]
                                                                   ]
            }
          ]
        }
      end
      
      def self.check_config(config)
        config
      end
      
    end
  end
end
