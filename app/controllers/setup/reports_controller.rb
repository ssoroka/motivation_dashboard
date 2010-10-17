class Setup::ReportsController < Setup::ApplicationController

  def new
    @report = @data_set.reports.build
    @config_info = integration_constant.info
  end
  
  def create
    @report = @data_set.reports.build(params[:report])
    @config = integration_constant
    @config_info = @config.info
    
    config_result = @config.check_config(params[:custom_config]) 
    @report.config = config_result if config_result
    
    if config_result && @report.save
      redirect_to [:new, :setup, @data_source, @data_set, @report, :widget]
    else
      render :action => :new
    end    
  end

  def edit
    @report = @data_set.reports.find(params[:id])
  end
  
  def update
    @report = @data_set.reports.find(params[:id])
    
    if @report.update_attributes(params[:data_set])
      redirect_to [:new, :setup, @data_source, @data_set, @report, :widget] # Should redirect to existing page - Nathan 3:33PM SAT
    else
      render :action => :edit
    end
  end

  private
    def integration_constant
      "Integration::#{@data_source.integration.to_s.camelcase}::Report".constantize
    end
end