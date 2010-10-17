class Setup::DataSourcesController < Setup::ApplicationController
  # Note: We may want to throw an exception or redirect them to the index action if they tamper with data_source param - Nathan 2:23PM SAT
  
  def index
  end
  
  def new
    @data_source = DataSource.new
    @config_info = integration_constant.info
  end                                                                                      
                                                                                           
  def create                                                                               
    @config = integration_constant
    @config_info = @config.info
        
    @data_source = DataSource.new(params[:data_source])
    @data_source.integration = params[:integration]
    
    config_result = @config.check_config(params[:custom_config])
    @data_source.config = config_result if config_result
    
    if config_result && @data_source.save
      redirect_to [:new, :setup, @data_source, :data_set]
    else
      render :action => :new
    end
    
  end
  
  def auth_receive
    if params[:token]
      @data_source = DataSource.new
      @data_source.integration = params[:integration]
      config_result = integration_constant.check_config({:authsub_token => params[:token]})
      @data_source.config = config_result if config_result

      if config_result && @data_source.save
        redirect_to [:new, :setup, @data_source, :data_set]
      else
        redirect_to new_setup_data_source_path(:integration => params[:integration])
      end
    else
      redirect_to new_setup_data_source_path(:integration => params[:integration])
    end
  end
  
  private
    
    def integration_constant
      "Integration::#{params[:integration].camelcase}::DataSource".constantize
    end
  
end