class Setup::ReportsController < Setup::ApplicationController

  def new
    @report = Report.new
  end
  
  def create
    @report = Report.new(params[:data_set])
    
    if @report.save
      redirect_to [:new, :setup, @data_source, @data_set, @report, :widget]
    else
      render :action => :new
    end    
  end

  def edit
    @report = Report.find(params[:id])
  end
  
  def update
    @report = Report.find(params[:id])
    
    if @report.update_attributes(params[:data_set])
      redirect_to [:new, :setup, @data_source, @data_set, @report, :widget] # Should redirect to existing page - Nathan 3:33PM SAT
    else
      render :action => :edit
    end
  end


end