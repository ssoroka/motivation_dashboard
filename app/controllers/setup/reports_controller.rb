class Setup::ReportsController < Setup::ApplicationController

  def new
    @report = @data_set.reports.build
    @config_info = integration_klass.const_get('Report').info
  end
  
  # {"commit"=>"Next", "data_set_id"=>"4", "data_source_id"=>"4", "authenticity_token"=>"pJIC3IM8rlGaf8nwUwZWqJyglyAMOm1If0Ko4zJgM9s=", "utf8"=>"\342\234\223", "custom_config"=>{"report_type"=>"unread_messages_table"}}
  def create
    @report = @data_set.reports.build(params[:report])
    @config = integration_klass.const_get('Report')
    @config_info = @config.info
    
    config_result = @config.check_config(params[:custom_config]) 
    @report.config = config_result if config_result
    
    if config_result && @report.save
      @widget = @report.widgets.build
      @widget.dashboard = current_user.dashboard
      @widget.widget_type_id = Widget::WIDGET_TYPES[data_source_report_type_constant[params['custom_config']['report_type']]]
      @widget.widget_size = 2 if [:line, :table].include?(data_source_report_type_constant[params['custom_config']['report_type']])
      current_user.set_next_poll_at!
      if @widget.save
        redirect_to dashboard_path
      end
    else
      render :action => :new
    end    
  end
  
  private
    def integration_klass
      "Integration::#{@data_source.integration.to_s.camelcase}".constantize
    end
    
    def data_source_report_type_constant
      integration_klass.const_get('REPORT_TYPES')
    end
end
