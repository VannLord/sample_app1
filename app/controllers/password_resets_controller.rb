class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user,
                :check_expiration, only: [:edit, :update]

  def new; end

  def edit; end

  def update
    if @user.update(user_params)
      log_in @user
      flash[:success] = t "index.be_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "index.reset_email"
      redirect_to root_url
    else
      flash.now[:danger] = t "index.invalid_email"
      render :new
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = "index.nil_user"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "index.reset_expired"
    redirect_to new_password_reset_url
  end
end
