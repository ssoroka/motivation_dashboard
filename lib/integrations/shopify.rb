require 'json'
require 'shopify_api'
require 'active_support/time'

class Integration
  class Shopify

    API_KEY = 'ce4f6995cf320e00daa4be4fcb178d67'
    SECRET  = '4095ab31e7ca34e2468f4cbc360c9d49'

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
      # This stuff will be in the DataSource model
      ShopifyAPI::Session.setup(:api_key => API_KEY, :secret => SECRET)
      @session = ShopifyAPI::Session.new(options[:shop_url], options[:token])
      ActiveResource::Base.site = @session.site
    end

    def perform
      # This should check what type of data is needed, and run the appropriate
      # method(s).
      unfulfilled_orders
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

      { :last_month => last_month, :month_to_date => month_to_date }
    end

    def order_statuses
      statuses = {}
      statuses[:authorized] = ShopifyAPI::Order.count(:financial_status => 'authorized')
      statuses[:pending]    = ShopifyAPI::Order.count(:financial_status => 'pending')
      statuses[:unshipped]  = ShopifyAPI::Order.count(:fulfillment_status => 'unshipped')
      statuses[:partially_shipped] = ShopifyAPI::Order.count(:fulfillment_status => 'partial')
      statuses
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
