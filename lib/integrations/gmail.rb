require 'open-uri'
require 'gdata'
require 'nokogiri'
require 'time'

class GmailIntegration

  def self.perform(*args)
    new(*args).perform
  end

  def initialize(options)
    @client = GData::Client::GMail.new
    @client.authsub_token = options[:authsub_token]
  end

  def perform
    unread_messages_count
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

end
