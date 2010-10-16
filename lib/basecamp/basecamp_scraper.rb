require 'lib/basecamp/basecamp_wrapper'

class BasecampScraper
  
  def perform(option)
    token = "2b9e4476562656b04e306ccbb93f47cf1340cfc8";
    subdomain = "skipants"
    
    Basecamp.establish_connection!("#{subdomain}.grouphub.com", token, "X")
  end
  
end