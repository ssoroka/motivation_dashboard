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

    if params[:redirect_url]
      redirect_to @config.redirect_url(params[:custom_config],
                                       auth_receive_setup_data_sources_url(:integration => params[:integration]))
      return
    end

    @data_source.integration = params[:integration]

    config_result = @config.check_config(params[:custom_config])
    @data_source.config = config_result if config_result

    if config_result && @data_source.save
      redirect_to [:new, :setup, @data_source, :data_set]
    else
      flash.now[:error] = 'There was something wrong with the settings. Please re-check what you entered.'
      render :action => :new
    end

  end

  def auth_receive
    @data_source = current_user.data_sources.build
    @data_source.integration = params[:integration]

    config_result = integration_klass.check_config(params)
    @data_source.config = config_result if config_result

    if config_result && @data_source.save
      redirect_to [:new, :setup, @data_source, :data_set]
    else
      flash[:error] = 'Your third-party authentication is invalid. Please retry.'
      redirect_to new_setup_data_source_path(:integration => params[:integration])
    end
  end

  private

    def integration_klass
      "Integration::#{params[:integration].camelcase}::DataSource".constantize
    end

end
