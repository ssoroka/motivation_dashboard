module DashboardHelper
  def display_widgets(widgets)
    javascript_tag(raw("var widgets = #{widgets.to_json};"))
  end
  
  def not_set(attribute)
    attribute.blank? ? 'Not Set' : attribute
  end
end