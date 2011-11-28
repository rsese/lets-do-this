class TasksController < ApplicationController
  before_filter :authenticate

  def create
    @task = current_user.created_tasks.new(params[:task])
    if @task.save
      @task.position = max_position(Task.where(:assigned_to_id => @task.assigned_to_id))
      @task.save
      flash[:success] = "Task created."
    else

      # TODO: Use Active Record error messages
      if @task.description.empty?
        flash[:error] = "Sorry, the task description can't be empty."
      else
        flash[:error] = "Problem creating that task.  Try again later?."
      end

      redirect_to new_task_path(
        :assigned_to => params[:task][:assigned_to_id]) and return
    end
    redirect_to root_path + user_anchor(User.find(@task.assigned_to_id))
  end

  def destroy
    user = User.find(Task.find(params[:id]).assigned_to_id)
    Task.find(params[:id]).destroy
    flash[:success] = "Task deleted."
    redirect_to root_path + user_anchor(user)
  end

  def edit
    @task = Task.find(params[:id])
    @title = "Edit Task"
    @user_names_ids = []
    User.all.each do |u|
      @user_names_ids << ["#{u.first_name} #{u.last_name}", u.id]
    end
  end

  def update
    @task = Task.find(params[:id])
    old_assigned_to = params[:old_assigned_to_id]

    if old_assigned_to != params[:task][:assigned_to_id]
      p "taking it from: " + User.find(old_assigned_to).first_name
      p "giving it to: " + User.find(params[:task][:assigned_to_id]).first_name
       
      params[:task][:position] = max_position(Task.where(:assigned_to_id => params[:task][:assigned_to_id]))
    end 
    if @task.update_attributes(params[:task])
      flash[:success] = "Task updated."
    else 
      flash[:error] = "Error Updating Task."
    end
    redirect_to root_path + user_anchor(User.find(old_assigned_to))
  end

  def new
    @task = current_user.created_tasks.new(params[:task])
    begin
      @assigned_to = User.find(params[:assigned_to])
    rescue
      flash[:error] = "There's no user buddy."
      redirect_to root_path
    end
  end

  def remote_edit_tasks
    task = Task.find(params[:task_id])
    task.description = params[:task_description]

    if task.save
      # flash[:success] = "Task created."
    else
      # flash[:error] = "Problem creating that task.  Try again later?."
    end
    render :inline => task.description
  end
end
