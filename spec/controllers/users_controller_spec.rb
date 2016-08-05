require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #update' do
    let(:user) { create :user, password: '111', password_confirmation: '111' }

    context 'with valid params' do
      before { patch :update, id: user, user: { old_password: '111',
                                                password: '222',
                                                password_confirmation: '222' } }

      it 'update user\'s password' do
        user.reload
        expect(user.valid_password?('222')).to eq true
      end

      it 'redirects to edit' do
        expect(response).to redirect_to edit_user_path user
      end
    end

    context 'with invalid params' do
      before { patch :update, id: user, user: { old_password: '000',
                                                password: '222',
                                                password_confirmation: '222' } }

      it 'does not update user\'s password' do
        user.reload
        expect(user.valid_password?('222')).to eq false
      end

      it 'rerenders :edit' do
        expect(response).to render_template :edit
      end
    end
  end
end
