module AuthenticationForFeatureRequest
  # def login user, password = '123'
    # page.driver.post user_sessions_url, user: { email: user.email, password: password }
    # visit root_url
  # end
  #
  def login user, password = 123
    visit login_path
    fill_in :user_email, with: user.email
    fill_in :user_password, with: password
    click_on 'Авторизоваться'
  end
end
