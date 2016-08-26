class UsersController < ApplicationController
  before_action :load_user, only: [:edit, :update, :destroy]

  def index
    if Rails.env.development?
      @users = User.all
    else
      render nothing: true
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path, notice: t(:user_update)
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path
    end
  end


  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :old_password,
      :locale
    )
  end
end
