namespace :send_email do
  desc 'Send email to user if there are pending cards'
  task pending_cards: :environment do
    User.notify_pending_cards
  end
end
