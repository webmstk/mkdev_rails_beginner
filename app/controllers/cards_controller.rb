class CardsController < ApplicationController
  before_action :load_card, only: [:edit, :update, :destroy]

  def index
    @cards = Card.all
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)

    if @card.save
      redirect_to cards_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path
    else
      render :edit
    end
  end

  def destroy
    redirect_to cards_path, notice: 'Карточка удалена' if @card.destroy
  end

  def random
    # for any DB
    # rand_id = rand(Card.count)
    # @card = Card.where("id >= #{rand_id}").first

    # for postgresql
    @card = Card.review.order('RANDOM()').first
  end

  def check
    @card = Card.find(params[:card_id])

    if @card.translation_correct?(params[:card][:translated_text])
      @card.set_review_date.save
      redirect_to card_random_path, notice: 'Правильно'
    else
      if params[:card][:translated_text].empty?
        flash.now[:error] = 'Поле не может быть пустым'
      else
        flash.now[:error] = "<b>Текст:</b> #{@card.original_text}<br />
                             <b>Правильно:</b> #{@card.translated_text}".html_safe
      end

      render :random
    end
  end

  private

  def load_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text)
  end
end