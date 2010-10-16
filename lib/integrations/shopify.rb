require 'json'
require 'shopify_api'

class ShopifyIntegration

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
    unfullfilled_orders
  end

  def unfullfilled_orders
    unshipped = ShopifyAPI::Order.find(:all, :params=> {:fulfillment_status => 'unshipped', :fields => 'id'})
    partial = ShopifyAPI::Order.find(:all, :params=> {:fulfillment_status => 'partial', :fields => 'id'})
    unshipped.length + partial.length
  end


end
