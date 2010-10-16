class Widget < ActiveRecord::Base
  belongs_to :dashboard
  belongs_to :data_set
  
  WIDGET_TYPES = {:pie => 1, :bar => 2, :line => 3, :table => 4, :count => 5, :ticker => 6, :map => 7, :image => 8, :calendar => 9, :tag_cloud => 10, :html => 11}
end
