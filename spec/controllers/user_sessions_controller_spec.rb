require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #create' do
    context 'with valid params' do
      it 'returns http success' do
        get :create, user: { email: 'test@mail.ru', password: '123456' }
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'returns renders #new' do
        get :create, user: { email: '', password: '' }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #destroy' do
    it 'returns http success' do
      get :destroy
      expect(response).to redirect_to root_path
    end
  end

end
