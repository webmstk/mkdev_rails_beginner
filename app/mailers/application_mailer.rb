class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM_NOREPLY']
  layout 'mailer'
end
