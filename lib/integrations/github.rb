require 'json'
class Github
  
  # Some fun test data 
  #
  # params = {}
  # params[:payload] = '{
  #   "after": "0d47df37b40bbf6c2172e83596c0334390d0c558", 
  #   "before": "83814b06b9d403f3f9e43589ee137c3cac44d182", 
  #   "commits": [
  #     {
  #       "added": [], 
  #       "author": {
  #         "email": "jonathan@titanous.com", 
  #         "name": "Jonathan Rudenberg"
  #       }, 
  #       "id": "0d47df37b40bbf6c2172e83596c0334390d0c558", 
  #       "message": "Make Gmail integration even more awesome", 
  #       "modified": [
  #         "lib\/integrations\/gmail.rb"
  #       ], 
  #       "removed": [], 
  #       "timestamp": "2010-10-16T06:03:42-07:00", 
  #       "url": "https:\/\/github.com\/railsrumble\/rr10-team-232\/commit\/0d47df37b40bbf6c2172e83596c0334390d0c558"
  #     }
  #   ], 
  #   "compare": "https:\/\/github.com\/railsrumble\/rr10-team-232\/compare\/83814b0...0d47df3", 
  #   "forced": false, 
  #   "pusher": {
  #     "email": "jonathan@titanous.com", 
  #     "name": "titanous"
  #   }, 
  #   "ref": "refs\/heads\/master", 
  #   "repository": {
  #     "created_at": "2010\/10\/15 10:36:58 -0700", 
  #     "description": "Repository for the RailsRumble 2010 Team 232", 
  #     "fork": false, 
  #     "forks": 0, 
  #     "has_downloads": true, 
  #     "has_issues": true, 
  #     "has_wiki": true, 
  #     "name": "rr10-team-232", 
  #     "open_issues": 0, 
  #     "owner": {
  #       "email": "organizers@railsrumble.com", 
  #       "name": "railsrumble"
  #     }, 
  #     "private": true, 
  #     "pushed_at": "2010\/10\/16 06:03:44 -0700", 
  #     "url": "https:\/\/github.com\/railsrumble\/rr10-team-232", 
  #     "watchers": 1
  #   }
  # }'
  


  def initialize(params)
    @payload = JSON.parse(params[:payload])
  end
  
  def parsed
    @payload['commits'].each do |commit|
      [commit['author']['name'], commit['author']['message'], commit['author']['timestamp']]
    end
  end


end