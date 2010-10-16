class Setup::DataSourcesController < Setup::ApplicationController
  # Note: We may want to throw an exception or redirect them to the index action if they tamper with data_source param - Nathan 2:23PM SAT
  
  def index

  end
  
  def new
    @data_source = DataSource.new
    @config = "Integration::#{params[:integration].classify}::DataSource".constantize 
    @config_info = @config.info
  end                                                                                      
                                                                                           
  def create                                                                               
    @config = "Integration::#{params[:integration].classify}::DataSource".constantize 
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
  
end