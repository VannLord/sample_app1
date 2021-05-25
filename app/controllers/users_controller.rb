class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :check_admin, only: :destroy

  def new
    @user = User.new
  end

  def destroy
    if @user.destroy
      flash[:sucess] = t "index.user_deleted"
    else
      flash[:danger] = t "index.delete_fail"
    end
    redirect_to users_url
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "index.check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def update
    if @user.update(user_params)
      flash[:sucess] = t "index.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def following
    @title = t("index.following")
    @users = @user.following.paginate(page: params[:page])
    render :show_follow
  end

  def followers
    @title = t("index.followers")
    @users = @user.followers.paginate(page: params[:page])
    render :show_follow
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
end
