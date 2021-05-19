class AccountActivationsController < ApplicationController
  before_action :valid_link?, only: :edit

  def edit
    @user.activate
    log_in @user
    flash[:success] = t "index.activated"
    redirect_to @user
  end

  def valid_link?
    @user = User.find_by email: params[:email]
    return if @user && !@user.activated &&
              @user.authenticated?(:activation, params[:id])

    flash[:danger] = t "index.invalid_active_link"
    redirect_to root_path
  end
end
