require 'rails_helper'

RSpec.describe Authentication, type: :model do
  it { should belong_to :user }
end
