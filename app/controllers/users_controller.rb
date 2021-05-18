class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :check_admin, only: :destroy
  def show; end

  def edit; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "index.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:sucess] = t "index.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:sucess] = t "index.user_deleted"
    else
      flash[:danger] = t "index.delete_fail"
    end
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "index.nil_user"
    redirect_to root_path
  end

  def check_admin
    return if @current_user.admin?

    flash[:danger] = t "index.not_authenticated"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "index.pls_login"
    redirect_to login_url
  end
end
