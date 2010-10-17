require 'open-uri'
require 'json'

class Integration
  class GetSatisfaction
    REPORT_TYPES = HashWithIndifferentAccess.new({ :unanswered_topics => :table })
    API_HOST = 'http://api.getsatisfaction.com'

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
      @company_name = options[:company_name]
    end

    def perform(data_set_config, report_config)
      @product = data_set_config[:product]
      unanswered_topics
    end

    def unanswered_topics
      product = @product.present? ? "/products/#{@product}" : ''
      result = open(API_HOST + "/companies/#{@company_name + product}/topics.json?style=problem&sort=unanswered").read
      result = JSON.parse(result)
      topics = result['data']
      rows = topics.map do |topic|
        subject = "<a href=\"#{topic['url']}\">#{topic['subject']}</a>"
        [subject, topic['follower_count'], topic['reply_count']]
      end

      rows.sort!{ |a,b| b[1].to_i <=> a[1].to_i }

      {
        'label' => "#{@company_name} - Unanswered Support Messages",
        'headers' => ['Subject', 'Followers', 'Replies'],
        'rows' => rows.map { |row| { 'row' => row } }
      }
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
          :description => 'Get Satisfaction shows you unanswered questions from your community.
            To do this, Motivation Dashboard needs your company name. (ex. if your Get Satisfaction URL is
            getsatisfaction.com/secretsauce then the company name is secretsauce)',
          :fields => [
            { :name => :company_name, :type => :string }
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
          :description => 'Which product would you like to see support requests for?',
          :fields => [
            { :name => :product, :type => :select, :options => [['All', nil]] + products.to_a, :label => nil }
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
            { :name => :report_type, :type => :select, :options => [['Unanswered Topics', :unanswered_topics]] }
          ]
        }
      end

      def self.check_config(config)
        config
      end

    end
  end
end
