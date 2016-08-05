class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if (@user = login(params[:user][:email], params[:user][:password]))
      redirect_back_or_to :root, notice: 'Вы успешно авторизовались'
    else
      @user = User.new(login_attributes)
      flash.now.alert = 'Неправильный логин/пароль'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Выход выполнен успешно'
  end

  private

  def login_attributes
    params.require(:user).permit(:email, :password)
  end
end
