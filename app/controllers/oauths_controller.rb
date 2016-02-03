class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    # я бы очень хотел вынести это в модель User, но не могу заставить там работать login_from

    if login_from(provider)
      redirect_to root_path, notice: "Вы авторизовались через #{provider.titleize}!"
    else
      begin
        user = create_from(provider)
      rescue
        user = User.where(email: @user_hash[:user_info]['email']).first
        user.create_authentication(provider, @user_hash[:uid]) if user
      end

      if user
        reset_session
        auto_login(user)

        redirect_to root_path, notice: "Вы авторизовались через #{provider.titleize}!"
      else
        redirect_to root_path, alert: "Не получилось авторизоваться через #{provider.titleize}!"
      end
    end
  end


  private

  def auth_params
    params.permit(:code, :provider)
  end
end