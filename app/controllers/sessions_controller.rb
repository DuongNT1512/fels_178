class SessionsController < ApplicationController
  def new
    redirect_to root_url if logged_in?
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      user.admin? ? redirect_to(admin_root_path) : redirect_to(root_path)
    else
      flash.now[:danger] = t "containt.notice"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
