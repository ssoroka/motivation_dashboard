module ApplicationHelper
  
  def custom_config_field(config_field)
    case config_field[:type]
    when :string
      text_field_tag "custom_config[#{config_field[:name]}]", params[:custom_config] ? params[:custom_config][config_field[:name].to_sym] : nil, :class => :text
    when :select
      select_tag "custom_config[#{config_field[:name]}]", options_for_select(config_field[:options])
    when :authsub
      link_to config_field[:url_text] || 'Authorize Account', config_field[:url].call(auth_receive_setup_data_sources_url(:integration => params[:integration]))
    when :shopify
      hidden_field_tag :shopify, true
    end
  end
  
end
