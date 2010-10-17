class Setup::DataSetsController < Setup::ApplicationController

  def new
    @data_set = @data_source.data_sets.build
    @config_info = integration_constant.info(@data_source.config)
        
    if @config_info.blank?
      @data_set.data_source_id = @data_source.id
      if @data_set.save
        redirect_to [:new, :setup, @data_source, @data_set, :report]
      else
        flash.now[:error] = 'There was something wrong with the settings. Please re-check what you entered.'
        redirect_to [:new, :setup, @data_source]
      end
    end
    
  end
  
  def create
    @config = integration_constant
    @config_info = @config.info(@data_source.config)
        
    @data_set = @data_source.data_sets.build(params[:data_set])
    
    config_result = @config.check_config(params[:custom_config]) 
    @data_set.config = config_result if config_result
    
    if config_result && @data_set.save
      # config.perform
      redirect_to [:new, :setup, @data_source, @data_set, :report]
    else
      flash.now[:error] = 'There was something wrong with the settings. Please re-check what you entered.'
      render :action => :new
    end    
  end

  def edit
    @data_set = @data_source.data_sets.find(params[:id])
  end
  
  def update
    @data_set = @data_source.data_sets.find(params[:id])
    
    if @data_set.update_attributes(params[:data_set])
      redirect_to [:new, :setup, @data_source, @data_set, :report] # Should redirect to existing page - Nathan 3:33PM SAT
    else
      flash.now[:error] = 'There was something wrong with the settings. Please re-check what you entered.'
      render :action => :edit
    end
  end

  private
    
    def integration_constant
      "Integration::#{@data_source.integration.to_s.camelcase}::DataSet".constantize
    end

end


