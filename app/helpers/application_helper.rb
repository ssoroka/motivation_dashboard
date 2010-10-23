module ApplicationHelper

  def custom_config_field(config_field)
    case config_field[:type]
    when :string
      text_field_tag "custom_config[#{config_field[:name]}]", params[:custom_config] ? params[:custom_config][config_field[:name].to_sym] : nil, :class => :text
    when :select
      select_tag "custom_config[#{config_field[:name]}]", options_for_select(config_field[:options])
    when :hidden
      hidden_field_tag "custom_config[#{config_field[:name]}]", config_field[:value]
    when :timezone_select
      # TODO - We can calculate the current users system time zone and default this drop down to that
      # or maybe we can include major cities instead. Ie. London, New York, Tokoyo  - Nathan 22nd/Oct/2010
      select_tag "custom_config[#{config_field[:name]}]", options_for_select(ActiveSupport::TimeZone.all.collect{|t| [t.name, t.utc_offset]})
    when :redirect_url
      hidden_field :redirect_url, true
    end
  end

end