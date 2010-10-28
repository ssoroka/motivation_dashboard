class BigBrother::UsersController < BigBrother::ApplicationController
    
  def index
    @users = User.paginate(:per_page => 50, :page => params[:page], :order => 'users.last_name ASC')
  end
  
  def search
    # TODO - Refactor me, this is tad bit FUUUUGGGGLLLY . Nathan - 28th Oct 2010
    s = params[:search].split(' ')
    @users = User.paginate(:per_page => 50, :page => params[:page], :conditions => ['first_name LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR last_name LIKE ? OR id LIKE ? OR email LIKE ?', "%#{s[0]}%", "%#{s[-1]}%", "%#{s[0]}%", "%#{s[-1]}%", params[:search], params[:search]], :order => 'users.last_name ASC')
  end  
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile for '#{@user.user_bar_name}'."
      redirect_to [:big_brother, :users]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:notice] = "Successfully permanently removed '#{@user.user_bar_name}'."
    else
      flash[:error] = "Failed to permanently remove '#{@user.user_bar_name}'."
    end
    
    redirect_to [:big_brother, :users]
  end
end