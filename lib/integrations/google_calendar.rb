require 'gcal4ruby'

class Integration  
  class GoogleCalendar

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options)
      @service = GCal4Ruby::Service.new
      @service.authenticate(options[:gmail], options[:password])
      @events = @service.events
    end

    def perform
      events
    end

    def events
      counts = @events.map do |event|
        [event.title, event.start_time.strftime("%I:%M%p %m/%d/%Y"), event.end_time.strftime("%I:%M%p %m/%d/%Y"), event.attendees.size]
      end
    end
  
  end
end