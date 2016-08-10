require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let!(:card) { create :card, :expired, user: user }
  let!(:other_card) { create :card, :expired, user: other_user }
  let(:deck) { create :deck }

  before { login_user user }

  describe '#index' do
    before { get :index }

    it 'shows user\'s cards' do
      expect(assigns :cards).to include card 
    end

    it 'does not show other_user\'s cards' do
      expect(assigns :cards).to_not include other_card
    end
  end

  describe '#random' do
    before { get :random }

    it 'shows card' do
      expect(assigns :card).to eq card
    end

    it 'the owner is user' do
      expect(assigns(:card).user_id).to eq user.id
    end
  end

  describe 'create' do
    context 'not authorized' do
      before { logout_user }

      it 'does not save card in the database' do
        expect { post :create, card: attributes_for(:card, deck_id: deck) }.to_not change(Card, :count)
      end

      it 'redirects to new_card_path' do
        post :create, card: attributes_for(:card, deck_id: deck)
        expect(response).to redirect_to new_card_path
      end

      it 'renders error message' do
        post :create, card: attributes_for(:card, deck_id: deck)
        expect(flash[:error]).to eq 'Залогиньтесь!'
      end
    end

    context 'authorized' do
      it 'saves card in the database' do
        expect { post :create, card: attributes_for(:card, deck_id: deck) }.to change(Card, :count).by 1
      end

      it 'belongs to user' do
        post :create, card: attributes_for(:card, deck_id: deck)
        expect(Card.last.user_id).to eq user.id
      end
    end
  end

  describe '#update' do
    context 'not authorized'do
      before { logout_user }

      it 'does not update card params' do
        expect { put :update, id: card, card: attributes_for(:card) }.to_not change(Card, :count)
      end

      it 'redirects to new_card_path' do
        put :update, id: card, card: attributes_for(:card)
        expect(response).to redirect_to edit_card_path(card)
      end

      it 'renders error message' do
        put :update, id: card, card: attributes_for(:card)
        expect(flash[:error]).to eq 'Залогиньтесь!'
      end
    end

    context 'other_user\'s card' do
      before do
        put :update, id: other_card, card: attributes_for(:card, original_text: 'upd')
      end

      it 'does not update card params' do
        other_card.reload
        expect(other_card.original_text).not_to eq 'upd'
      end

      it 'redirects ot edit_card_path' do
        expect(response).to redirect_to edit_card_path(other_card)
      end

      it 'renders error message' do
        expect(flash[:error]).to eq 'Нельзя изменять чужие карточки!'
      end
    end
    
    context 'user\'s card' do
      context 'valid params' do
        before do
          put :update, id: card, card: attributes_for(:card, original_text: 'upd')
        end

        it 'updates card\'s attributes' do
          card.reload
          expect(card.original_text).to eq 'upd'
        end

        it 'redirects to card_edit_path' do
          expect(response).to redirect_to edit_card_path(card)
        end

        it 'show success message' do
          expect(flash[:notice]).to eq 'Данные успешно обновлены'
        end
      end

      context 'invalid params' do
        before do
          put :update, id: card, card: attributes_for(:card, original_text:   'upd',
                                                             translated_text: 'upd')
        end

        it 'does not update card\'s attributes' do
          card.reload
          expect(card.original_text).to_not eq 'upd'
        end

        it 'rerenders :edit' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe '#destroy' do
    context 'not authorized' do
      before { logout_user }

      it 'does not delete card' do
        expect { delete :destroy, id: card }.to_not change(Card, :count)
      end

      it 'redirects to cards_path' do
        delete :destroy, id: card
        expect(response).to redirect_to cards_path
      end

      it 'renders error message' do
        delete :destroy, id: card
        expect(flash[:error]).to eq 'Залогиньтесь!'
      end
    end

    context 'delete user\'s card' do
      it 'deletes the card from the database' do
        expect { delete :destroy, id: card }.to change(Card, :count).by(-1)
      end

      it 'redirects to cards_path' do
        delete :destroy, id: card
        expect(response).to redirect_to cards_path
      end

      it 'shows success message' do
        delete :destroy, id: card
        expect(flash[:notice]).to eq 'Карточка удалена'
      end
    end

    context 'delete other_user\'s card' do
      it 'does not delete card' do
        expect { delete :destroy, id: other_card }.to_not change(Card, :count)
      end

      it 'redirects to cards_path' do
        delete :destroy, id: other_card
        expect(response).to redirect_to cards_path
      end

      it 'rendres error message' do
        delete :destroy, id: other_card
        expect(flash[:error]).to eq 'Нельзя удалить чужую карточку!'
      end
    end
  end
end
