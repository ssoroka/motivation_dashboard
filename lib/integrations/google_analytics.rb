require 'garb'
require 'active_support/time'

class GoogleAnalyticsIntegration

  attr_reader :profile
  
  REPORT_TYPES = {:visitors => 1, :visits => 2, :pageviews => 3, :unique_pageviews => 4, :goal_completions => 5}

  def self.perform(*args)
    new(*args).perform
  end
  
  def initialize(options)
    Garb::Session.auth_sub options[:authsub_token]
    @profile = Garb::Profile.first(options[:property_id])
  end


  def goal_conversions_by_day(goal_id)
    metric_by_day("goal#{goal_id}_completions".to_sym)
  end

  # view_type can be one of [:visitors, :visits, :pageviews, :unique_pageviews,
  #   :goal1_completions, etc]
  def metric_by_day(metric)
    { :month_to_date => month_to_date(metric), :last_month => last_month(metric) }
  end

  def month_to_date(metric)
    report = Garb::Report.new(@profile,
                              :start_date => Date.today.beginning_of_month,
                              :end_date => Date.today,
                              :dimensions => [:date],
                              :metrics => [metric])
    compile_report_to_day_array(report, metric)
  end

  def last_month(metric)
    report = Garb::Report.new(@profile,
                              :start_date => Date.today.beginning_of_month - 1.month,
                              :end_date => Date.today.beginning_of_month - 1.day,
                              :dimensions => [:date],
                              :metrics => [metric])
    compile_report_to_day_array(report, metric)
  end

  def compile_report_to_day_array(report, metric)
    report.results.map { |day| day.send(metric) }
  end

end
