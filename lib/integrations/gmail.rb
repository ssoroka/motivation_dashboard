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
    unread_messages
  end

  def unread_messages
    result = @client.get('https://mail.google.com/mail/feed/atom/unread/').body
    result = Nokogiri::XML(result)
    emails = result.css('entry').map do |email|
      subject = email.at_css('title').inner_text
      date = Time.parse(email.at_css('issued').inner_text)
      url = email.at_css('link')['href']
      sender = email.at_css('author name').inner_text
      subject = %Q(<a href="#{url}">#{subject}</a>)
      [date, sender, subject]
    end
  end

end
