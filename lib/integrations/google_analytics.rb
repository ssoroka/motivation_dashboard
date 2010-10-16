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

  # view_type can be one of [:visitors, :visits, :pageviews, :unique_pageviews]
  def views(view_type)
    report = Garb::Report.new(@profile, month_to_date.merge(:metrics => [view_type]))
    month_to_date = report.results.map { |day| day.send(view_type) }

    report = Garb::Report.new(@profile, last_month.merge(:metrics => [view_type]))
    last_month = report.results.map { |day| day.send(view_type) }

    { :month_to_date => month_to_date, :last_month => last_month }
  end

  def month_to_date
    {
      :start_date => Date.today.beginning_of_month,
      :end_date => Date.today,
      :dimensions => [:date]
    }
  end

  def last_month
    {
      :start_date => Date.today.beginning_of_month - 1.month,
      :end_date => Date.today.beginning_of_month - 1.day,
      :dimensions => [:date]
    }
  end

end
