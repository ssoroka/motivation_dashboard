require 'app/models/integration'
Dir['lib/integrations/*.rb'].each do |file|
  require file
end