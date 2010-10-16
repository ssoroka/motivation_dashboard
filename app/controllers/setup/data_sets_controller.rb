class Setup::DataSetsController < Setup::ApplicationController
  
  def new
    @data_set = DataSet.new
  end
  
  def create
    @data_set = DataSet.new(params[:data_set])
    
    if @data_set.save
      redirect_to [:new, :setup, @data_source, @data_set, :report]
    else
      render :action => :new
    end    
  end

  def edit
    @data_set = DataSet.find(params[:id])
  end
  
  def update
    @data_set = DataSet.find(params[:id])
    
    if @data_set.update_attributes(params[:data_set])
      redirect_to [:new, :setup, @data_source, @data_set, :report] # Should redirect to existing page - Nathan 3:33PM SAT
    else
      render :action => :edit
    end
  end

end


