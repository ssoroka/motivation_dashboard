class Widget < ActiveRecord::Base
  belongs_to :dashboard
  belongs_to :data_set
  
  WIDGET_TYPES = {:pie => 1, :bar => 2, :line => 3, :table => 4, :count => 5, :ticker => 6, :map => 7, :image => 8, :calendar => 9, :tag_cloud => 10, :html => 11}
  
  def as_json(options)
    {
      :position => position,
      :widget_size => widget_size, 
      :widget_type => WIDGET_TYPES.invert[widget_type_id],
      :widget_type_id => widget_type_id,
      :data => data_set.data,
      :config => data_set.config
    }
  end
end
