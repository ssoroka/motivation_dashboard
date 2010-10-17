require 'open-uri'
require 'gdata'
require 'nokogiri'
require 'time'

class Integration
  class Gmail
    REPORT_TYPES = { :unread_messages_table => :table, :unread_messages_count => :count }

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
      @client = GData::Client::GMail.new
      @client.authsub_token = options[:authsub_token]
    end

    def perform(data_set_config, report_config)
      send REPORT_TYPES.invert[report_config[:report_type].to_i]
    end

    def unread_messages_table
      emails = unread_messages.css('entry').map do |email|
        subject = email.at_css('title').inner_text
        date = Time.parse(email.at_css('issued').inner_text)
        url = email.at_css('link')['href']
        sender = email.at_css('author name').inner_text
        subject = %Q(<a href="#{url}">#{subject}</a>)
        [date, sender, subject]
      end
    end

    def unread_messages_count
      unread_messages.at_css('fullcount').inner_text.to_i
    end

    def unread_messages
      @unread_messages ||= Nokogiri::XML(@client.get('https://mail.google.com/mail/feed/atom/inbox/').body)
    end


    class DataSource
      def self.info
        {
          :description => 'List all the unread messages from your Gmail account',
          :fields => [{ :type => :redirect_url }]
        }
      end

      def self.check_config(params)
        begin
          token = GData::Client::GMail.new(:authsub_token => params[:token]).auth_handler.upgrade
          { :authsub_token => token }
        rescue
          false
        end
      end

      def self.redirect_url(config, url)
        GData::Client::GMail.new.authsub_url(url)
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
            { :name => :report_type, :type => :select, :options => [['Unread Messages Data', REPORT_TYPES[:unread_messages_table]],
                                                                      ['Unread Messages Count', REPORT_TYPES[:unread_messages_count]]] }
          ]
        }
      end

      def self.check_config(config)
        config
      end

    end

  end
end
