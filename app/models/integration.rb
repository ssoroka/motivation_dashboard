class Integration
  INTEGRATIONS = {:github => 1, :basecamp => 2, :get_statisfaction => 3, :gmail => 4, :google_analytics => 5, :shopify => 6}
 
  def self.for_select
    Integration::INTEGRATIONS.collect{|a,b| [a.to_s.humanize,b]}
  end
 
end