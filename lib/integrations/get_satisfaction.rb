require 'open-uri'
require 'json'

class GetSatisfactionIntegration
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

end
