require 'open-uri'
require 'json'
class GetSatisfactionScraper
  API_HOST = "http://api.getsatisfaction.com"

  def self.perform(options)
    result = JSON.parse open(API_HOST + "/companies/#{options[:company_name]}/topics.json?sort=unanswered").read
    topics = result["data"]
    rows = topics.map do |topic|
      subject = "<a href=\"#{topic["url"]}\">#{topic["subject"]}</a>"
      [subject, topic["follower_count"], topic["reply_count"]]
    end
    
    rows.sort!{ |a,b| b[1].to_i <=> a[1].to_i }
    
    rows.to_json
  end
  
end