require 'feedzirra'
require 'pismo'

class XMLFeedIntegration
  def self.perform(*args)
    new(*args).perform
  end

  def initialize(options)
    @feed_url = options[:feed_url]
  end

  def perform
    entry_titles
  end

  def entry_titles
    parse_feed.entries.map do |entry|
      %Q(<a href="#{entry.url}">#{entry.title.sanitize}</a>)
    end
  end

  def self.autodetect_feed_url(site_url)
    Pismo::Document.new(site_url).feed
  end

  def parse_feed
    Feedzirra::Feed.fetch_and_parse(@feed_url)
  end

  def valid_feed?
    parse_feed rescue false
  end
end
