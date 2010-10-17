require 'json'
require 'shopify_api'
require 'active_support/time'

class Integration
  class Shopify

    REPORT_TYPES = HashWithIndifferentAccess.new({ :unfulfilled_orders => :count, :monthly_sales => :line })

    API_KEY = 'ce4f6995cf320e00daa4be4fcb178d67'
    SECRET  = '4095ab31e7ca34e2468f4cbc360c9d49'

    def self.perform(*args)
      new(*args).perform
    end

    def self.setup_session
      ShopifyAPI::Session.setup(:api_key => API_KEY, :secret => SECRET)
    end

    def initialize(options)
      # This stuff will be in the DataSource model
      Shopify.setup_session
      @session = ShopifyAPI::Session.new(options[:shop_url], options[:token])
      ActiveResource::Base.site = @session.site
    end

    def perform(data_source_config, report_config)
      send report_config[:report_type].to_sym
    end

    def unfulfilled_orders
      unshipped = ShopifyAPI::Order.count(:fulfillment_status => 'unshipped')
      partial = ShopifyAPI::Order.count(:fulfillment_status => 'partial')
      unshipped + partial
    end

    def monthly_sales
      month_to_date = {}
      ShopifyAPI::Order.find_each(:params => { 
          :created_at_min => Time.now.beginning_of_month,
          :fields => 'created-at,subtotal-price' }) do |order|
        day = order.created_at.day
        month_to_date[day] ||= 0
        month_to_date[day] += order.subtotal_price
      end

      last_month = {}
      ShopifyAPI::Order.find_each(:params => {
          :created_at_min => Time.now.beginning_of_month - 1.month,
          :updated_at_max => Time.now.beginning_of_month - 1.day,
          :fields => 'created-at,subtotal-price' }) do |order|
        day = order.created_at.day
        last_month[day] ||= 0
        last_month[day] += order.subtotal_price
      end

      month_to_date = (0...Time.now.day).map do |day|
        month_to_date[day+1] || 0
      end

      last_month = (0...(Time.now.beginning_of_month - 1.day).day).map do |day|
        last_month[day+1] || 0
      end

      {
        :label => 'Monthly Sales',
        :x_type => 'days',
        :y_label => 'Sales',
        :line_labels => ['Sales Last Month',
                         'Sales This Month'],
        :lines => [last_month, this_month]
      }
    end

    def order_statuses
      statuses = {}
      statuses[:authorized] = ShopifyAPI::Order.count(:financial_status => 'authorized')
      statuses[:pending]    = ShopifyAPI::Order.count(:financial_status => 'pending')
      statuses[:unshipped]  = ShopifyAPI::Order.count(:fulfillment_status => 'unshipped')
      statuses[:partially_shipped] = ShopifyAPI::Order.count(:fulfillment_status => 'partial')
      statuses
    end

    class DataSource
      def self.info
        {
          :description => 'This Shopify intgration gives you graphs of sales.
            To get the data, Motivation Dashboard needs to have access to your Shopify store.
            When you press next, you will be taken to Shopify where you will be asked to install our app.',
          :fields => [
            { :name => :shop_url, :type => :string, :helper_text => 'Enter the URL of your Shopify store (ex. secretsauce.myshopify.com)' },
            { :type => :redirect_url }
          ]
        }
      end

      # Checks that the config is valid and returns it with any necessary modifications, if invalid, returns errors
      def self.check_config(params)
        begin
          Shopify.setup_session
          config = { :shop_url => params[:shop], :token => params[:t] }
          config if ShopifyAPI::Session.new(config[:shop_url], config[:token]).valid?
        rescue Exception => e
          false
        end
      end

      def self.redirect_url(config, url)
        Shopify.setup_session
        ShopifyAPI::Session.new(config[:shop_url]).create_permission_url
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
            { :name => :report_type, :type => :select, :options => [['Unfulfilled Orders', :unfulfilled_orders],
                                                                    ['Monthly Sales', :monthly_sales]] }
          ]
        }
      end

      def self.check_config(config)
        Shopify
        config
      end
    end


  end
end

# Batch helpers from http://github.com/jstorimer/shopify_app
module ShopifyAPI
 class Base < ActiveResource::Base
    def self.find_each(options = {})
      find_in_batches(options) do |records|
        records.each { |record| yield record }
      end

      self
    end

    def self.find_in_batches(options = {})
      options[:params] ||= {}
      page = 1
      limit = options.delete(:limit) || 100

      objects = find(:all, :params => {:page => page, :limit => limit}.merge(options[:params]))

      while objects.any?
        yield objects

        break if objects.size < limit
        page += 1
        objects = find(:all, :params => {:page => page, :limit => limit}.merge(options[:params]))
      end
    end
  end
end
