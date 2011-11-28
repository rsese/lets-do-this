class PagesController < ApplicationController
  def home
    @title = "Home"
    @users = User.order("first_name ASC")
    @task = Task.new
  end

  def about 
    @title = "About"
  end
end
