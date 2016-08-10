class DecksController < ApplicationController
  before_action :load_deck, only: [:edit, :update, :destroy, :current]

  def index
    @decks = Deck.ordered
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new deck_params
    if @deck.save
      redirect_to decks_path, notice: 'Колода создана'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @deck.update deck_params
      redirect_to edit_deck_path @deck
    else
      render :edit
    end
  end

  def destroy
    if @deck.destroy
      redirect_to decks_path, notice: 'Колода удалена'
    else
      redirect_to decks_path
      flash[:error] = 'Не получилось удалить колоду'
    end
  end

  def current
    if @deck.set_current
      render json: { status: 'ok' }
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
