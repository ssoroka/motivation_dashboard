class WidgetTemplatesController < ApplicationController
  respond_to :js
  
  def index
    @templates = Dir['app/views/widget_templates/*.html.mustache'].inject({}){|hash, f| hash[template_name(f)] = File.read(f); hash }
    respond_with(@templates)
  end
  
  private
    def template_name(file)
      File.basename(file).split('.')[0..-3].join('.').to_sym
    end
end