class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      handle_login user
    else
      flash.now[:danger] = t "index.wrong_login"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def handle_login user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end
end
