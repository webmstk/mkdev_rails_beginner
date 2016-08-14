class CardsController < ApplicationController
  before_action :load_card, only: [:edit, :update, :destroy]

  def index
    @cards = logged_in? ? Card.where(user: current_user) : []
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)

    if logged_in?
      @card.user = current_user
      
      if @card.save
        redirect_to cards_path
      else
        render :new
      end
    else
      redirect_to new_card_path
      flash[:error] = 'Залогиньтесь!'
    end
  end

  def edit
  end

  def update
    if logged_in?
      if @card.user_id == current_user.id
        if @card.update(card_params)
          redirect_to edit_card_path(@card)
          flash[:notice] = 'Данные успешно обновлены'
        else
          render :edit
        end
      else
        redirect_to edit_card_path(@card)
        flash[:error] = 'Нельзя изменять чужие карточки!'
      end
    else
      redirect_to edit_card_path(@card)
      flash[:error] = 'Залогиньтесь!'
    end
  end

  def destroy
    if logged_in?
      if @card.user_id == current_user.id
        redirect_to cards_path, notice: 'Карточка удалена' if @card.destroy
      else
        redirect_to cards_path
        flash[:error] = 'Нельзя удалить чужую карточку!'
      end
    else
      redirect_to cards_path
      flash[:error] = 'Залогиньтесь!'
    end
  end

  def random
    # for any DB
    # rand_id = rand(Card.count)
    # @card = Card.where("id >= #{rand_id}").first

    # for postgresql
    # @card = Card.review.where(user: current_user).order('RANDOM()').first

    @card = if current_user
              current_user.cards.review.order('RANDOM()').first
            else
              Card.review.order('RANDOM()').first
            end
  end

  def check
    @card = Card.find(params[:card_id])

    if @card.translation_correct?(params[:card][:translated_text])
      @card.success_up
      @card.delay_review_date
      redirect_to random_cards_path, notice: 'Правильно'
    else
      if params[:card][:translated_text].empty?
        flash.now[:error] = 'Поле не может быть пустым'
        render :random
      else
        @card.attempts_recalc
        redirect_to random_cards_path
        flash[:error] = "<b>Текст:</b> #{@card.original_text}<br />
                         <b>Правильно:</b> #{@card.translated_text}<br />
                         <b>А ты ввёл:</b> #{params[:card][:translated_text]}<br /><br />
                         Учи следующую карточку, лопух!"
      end
    end
  end

  private

  def load_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(
      :original_text,
      :translated_text,
      :image,
      :remove_image,
      :deck_id,
      :review_date
    )
  end
end
