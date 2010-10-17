class Setup::DataSourcesController < Setup::ApplicationController
  # Note: We may want to throw an exception or redirect them to the index action if they tamper with data_source param - Nathan 2:23PM SAT

  def index

  end

  def new
    @data_source = current_user.data_sources.build
    @config_info = integration_klass.info
  end

  def create
    @config = integration_klass
    @config_info = @config.info
        
    @data_source = current_user.data_sources.build(params[:data_source])

    if params[:shopify] # FUGLY HACK
      return redirect_to @config.install_url(params[:custom_config][:shop_url])
    end

    @data_source.integration = params[:integration]

    config_result = @config.check_config(params[:custom_config])
    @data_source.config = config_result if config_result

    if config_result && @data_source.save
      redirect_to [:new, :setup, @data_source, :data_set]
    else
      render :action => :new
    end

  end

  # This needs massive refactoring
  def auth_receive
    @data_source = current_user.data_sources.build
    @data_source.integration = params[:integration]

    if params[:token] # Authsub
      config_result = integration_klass.check_config(:authsub_token => params[:token])
      @data_source.config = config_result if config_result

      if config_result && @data_source.save
        redirect_to [:new, :setup, @data_source, :data_set]
      else
        redirect_to new_setup_data_source_path(:integration => params[:integration])
      end
    elsif params[:t] # Shopify
      config_result = integration_klass.check_config(:token => params[:t],
                                                     :shop_url => params[:shop])
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

    def integration_klass
      "Integration::#{params[:integration].camelcase}::DataSource".constantize
    end

end
