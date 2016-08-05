module AuthenticationForFeatureRequest
  def login user, password = '123'
    page.driver.post user_sessions_url, user: { email: user.email, password: password }
    visit root_url
  end
end
