module ApplicationHelper
  
  def custom_config_field(config_field)
    case config_field[:type]
    when :string
      text_field_tag "custom_config[#{config_field[:name]}]", params[:custom_config] ? params[:custom_config][config_field[:name].to_sym] : nil, :class => :text
    when :select
      select_tag "custom_config[#{config_field[:name]}]", options_for_select(config_field[:options])
    end
  end
  
end
