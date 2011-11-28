class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  before_filter :already_signed_in, :only => [:new, :create]

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "You're in the Tasks!"
      redirect_to user_path(@user)
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def show
    @user = User.find(params[:id])
    @title = "#{@user.first_name} #{@user.last_name}'s Profile"
    @assigned_tasks = @user.assigned_tasks
    @created_tasks = @user.created_tasks
  end

  def edit 
    @title = "Edit Your Profile"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated."
      redirect_to user_path(@user)
    else
      flash[:error] = "Problem Updating Profile."
      render 'edit'
    end
  end

  def index
    @users = User.order("first_name ASC")
    @title = "All Users"
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  def reorder_tasks
    p "serialize: #{params[:task]}"
    p "serialize: #{params}"
 
    original_order = Array.new()
 
    user = User.find(params[:user].to_i)
    user.assigned_tasks.each do |task|
      p "task# #{task.id}: position #{task.position}"
    end

    p 'POST vars'
    i = 1
    params[:task].each do |task| 
      p "task# #{task}: position #{i}"
      i += 1
      t = Task.find(task)
      t.position = i
      t.save
    end
    render :nothing => true
  end

  private
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:info] = "Can't edit that profile."
        redirect_to root_path
      end
    end

    def admin_user
      if !current_user.admin?
        flash[:info] = "Not enough priveleges to do delete users."
        redirect_to root_path
      end
    end

    def already_signed_in
      redirect_to root_path if signed_in?
    end
end
