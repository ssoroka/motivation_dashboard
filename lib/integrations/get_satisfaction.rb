require 'open-uri'
require 'json'

class Integration
  class GetSatisfaction
    REPORT_TYPES = {:unanswered_topics => 1}
    API_HOST = 'http://api.getsatisfaction.com'

    def self.perform(*args)
      new(*args).perform
    end
  
    def initialize(options)
      @company_name = options[:company_name]
    end

    def unanswered_topics
      result = open(API_HOST + "/companies/#{@company_name}/topics.json?sort=unanswered").read
      result = JSON.parse(result)
      topics = result['data']
      rows = topics.map do |topic|
        subject = "<a href=\"#{topic['url']}\">#{topic['subject']}</a>"
        [subject, topic['follower_count'], topic['reply_count']]
      end

      rows.sort!{ |a,b| b[1].to_i <=> a[1].to_i }
    end
    
    def products
      result = open(API_HOST + "/companies/#{@company_name}/products.json").read
      result = JSON.parse(result)
      products = {}
      result['data'].each do |product|
        products[product['name']] = product['id']
      end
      products
     end

    class DataSource
      def self.info
        {
          :description => 'Get Satisfaction is blah blah ...',
          :fields => [
            { :name => :company_name, :type => :string, :helper_text => 'Enter the name of your company.' }
          ]
        }
      end
    
      # Checks that the config is valid and returns it with any necessary modifications, if invalid, returns errors
      def self.check_config(config)
        begin
          info[:fields].each do |field|
            return false if config[field[:name]].blank?
          end
          # This needs to change - we need a better way to validate that a company exists
          Integration::GetSatisfaction.new(:company_name => config[:company_name]).products
          config
        rescue Exception => e
          false
        end
      end
    end
    
    
    class DataSet
      def self.info(data_source_config)
        products = Integration::GetSatisfaction.new(:company_name => data_source_config[:company_name]).products
        
        {
          :description => 'Choose a product from get satisfaction',
          :fields => [
            { :name => :product, :type => :select, :options => [['All', nil]] + products.to_a }
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
            { :name => :report_type, :type => :select, :options => [['Unanswered Topics', REPORT_TYPES[:unanswered_topics]]] }
          ]
        }
      end
      
      def self.check_config(config)
        config
      end
      
    end
  end
end