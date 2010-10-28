module DashboardHelper
  def display_widgets(widgets)
    javascript_tag(raw("var widgets = #{widgets.reverse.to_json};"))
  end
  
  def not_set(string)
    string.blank? ? 'Not Set' : string
  end
end