module DashboardHelper
  def display_widgets(widgets)
    javascript_tag(raw("var widgets = #{widgets.to_json};"))
  end
end