class Setup::DataSourcesController < Setup::ApplicationController
  # Note: We may want to throw an exception or redirect them to the index action if they tamper with data_source param - Nathan 2:23PM SAT
  
  def index

  end
  
  def new
    @data_source = DataSource.new
  end

  def create
    @data_source = DataSource.new(params[:data_source])
    @data_source.integration = params[:integration]
    
    if @data_source.save
      redirect_to [:new, :setup, @data_source, :data_set]
    else
      render :action => :new
    end
    
  end
  
end