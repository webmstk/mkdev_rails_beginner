class UsersController < ApplicationController
  before_action :load_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path, notice: 'Данные успешно обновлены'
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

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :old_password)
  end

  def load_user
    @user = User.find(params[:id])
  end
end