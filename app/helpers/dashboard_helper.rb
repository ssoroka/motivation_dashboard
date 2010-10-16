module DashboardHelper
  def display_widget(widget)
    
  end
  
  def not_set(attribute)
    attribute.blank? ? 'Not Set' : attribute
  end
end