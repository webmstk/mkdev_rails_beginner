class DecksController < ApplicationController
  before_action :load_deck, only: [:edit, :update, :destroy, :current]

  def index
    @decks = logged_in? ? current_user.decks.ordered : []
  end

  def new
    @deck = Deck.new
  end

  def create
    if logged_in?
    @deck = Deck.new deck_params
      @deck.user = current_user
      if @deck.save
        redirect_to decks_path, notice: t(:deck_created)
      else
        render :new
      end
    else
      redirect_to decks_path
      flash[:error] = t :login_message
    end
  end

  def edit
  end

  def update
    if logged_in?
      if @deck.user_id == current_user.id
        if @deck.update deck_params
          redirect_to edit_deck_path @deck
        else
          render :edit
        end
      else
        redirect_to edit_deck_path @deck
        flash[:error] = t :deck_change_no_permission
      end
    else
      redirect_to edit_deck_path @deck
      flash[:error] = t :login_message
    end
  end

  def destroy
    if logged_in?
      if @deck.user_id == current_user.id
        if @deck.destroy
          redirect_to decks_path, notice: t(:deck_deleted)
        else
          redirect_to decks_path
          flash[:error] = t :deck_not_deleted
        end
      else
        redirect_to decks_path
        flash[:error] = t :deck_delete_no_permission
      end
    else
      redirect_to decks_path
      flash[:error] = t :login_message
    end
  end

  def current
    if logged_in? && @deck.user_id == current_user.id
      if @deck.set_current current_user
        render json: { status: 'ok' }
      else
        render json: { status: 'fail' }
      end
    else
        render json: { status: 'fail' }
    end
  end

  private

  def load_deck
    @deck = Deck.find params[:id]
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
end
