require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :cards }
  it { should have_many :decks }
  it { should have_many :authentications }
  it { should validate_presence_of :email }
  it { should allow_value('test@mail.ru').for :email }
  it { should_not allow_value('asdf').for :email }

  describe 'uniqueness' do
    subject { build :user }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  let(:user) { create :user, email: 'test@mail.ru',
                             password: '123',
                             password_confirmation: '123' }

  describe '#update' do
    it 'update attributes' do
      user.update email: 'test222@mail.ru'
      user.reload
      expect(user.email).to eq 'test222@mail.ru'
    end
  end

  describe 'authentication' do
    context 'user had no password before' do
      let!(:user_without_pass) do
        user = build(:user, crypted_password: nil, salt: nil)
        user.save(validate: false)
        user
      end

      before do
        user_without_pass.update password: '123', password_confirmation: '123'
      end

      it 'passes without old_password' do
        expect(user_without_pass.errors.count).to eq 0
      end
    end

    context 'user had password' do
      it 'fails if no old_password provided' do
        user.update password: '321', password_confirmation: '321'
        expect(user.errors.messages[:old_password]).to include 'Введите текущий пароль'
      end

      it 'fails if wrong old_password provided' do
        user.update password: '321', password_confirmation: '321', old_password: 'wrong'
        expect(user.errors.messages[:old_password]).to include 'Неправильный пароль'
      end

      it 'passes if correct old_password provided' do
        user.update old_password: '123', password: '321', password_confirmation: '321'
        expect(user.errors.count).to eq 0
      end
    end
  end
end
