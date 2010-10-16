require 'garb'
require 'active_support/time'

class GoogleAnalyticsIntegration

  def self.perform(*args)
    new(*args).perform
  end

  def initialize(options)
    Garb::Session.auth_sub options[:authsub_token]
    @profile = Garb::Profile.first(options[:property_id])
  end

  def perform
    visits
  end

  def visits
    results = Visits.results(@profile, :start_date => Date.today.beginning_of_month,
                                       :end_date => Date.today)
    month_to_date = results.map { |day| day.visits }

    results = Visits.results(@profile, :start_date => Date.today.beginning_of_month - 1.month,
                                       :end_date => Date.today.beginning_of_month - 1.day)
    last_month = results.map { |day| day.visits }

    { :month_to_date => month_to_date, :last_month => last_month }
  end

  class Visits
    extend Garb::Resource

    metrics :visits
    dimensions :date
  end

end
