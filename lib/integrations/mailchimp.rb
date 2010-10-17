require 'hominid'

class Integration
  class Mailchimp

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
      @hominid = Hominid::Base.new({api_key => options[:api_key]})
    end

    def perform
      sends_remaining
    end

    def sends_remaining
      rows = @hominid.campaigns.map do |campaign|
        list = @hominid.find_list_by_id(campaign["list_id"])
        [campaign["subject"], campaign["from_email"], list["name"], list["member_count"], list["unsubscribe_count_since_send"]]
      end
    end
  end
end