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
      flash[:error] = t :login_message
    end
  end

  def edit
  end

  def update
    if logged_in?
      if @card.user_id == current_user.id
        if @card.update(card_params)
          redirect_to edit_card_path(@card)
          flash[:notice] = t :card_updated
        else
          render :edit
        end
      else
        redirect_to edit_card_path(@card)
        flash[:error] = t :card_change_no_permission
      end
    else
      redirect_to edit_card_path(@card)
      flash[:error] = t :login_message
    end
  end

  def destroy
    if logged_in?
      if @card.user_id == current_user.id
        redirect_to cards_path, notice: t(:card_deleted) if @card.destroy
      else
        redirect_to cards_path
        flash[:error] = t :card_delete_no_permission
      end
    else
      redirect_to cards_path
      flash[:error] = t :login_message
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

    if @card.translation_correct? params[:card][:translated_text]
      @card.translated_correct
      redirect_to random_cards_path, notice: t(:translation_correct)
    elsif @card.typo_in_translation? params[:card][:translated_text]
      @card.translated_correct
      redirect_to random_cards_path
      flash[:notice] = "<b>#{t :original_tex}:</b> #{@card.original_text}<br />
                       <b>#{t :translation_correct}:</b> #{@card.translated_text}<br />
                       <b>#{t :text_typed}:</b> #{params[:card][:translated_text]}<br /><br />
                       #{t :typo_happend}"
    else
      if params[:card][:translated_text].empty?
        flash.now[:error] = t(:translation_cannot_be_blank)
        render :random
      else
        @card.attempts_recalc
        redirect_to random_cards_path
        flash[:error] = "<b>#{t :original_text}:</b> #{@card.original_text}<br />
                         <b>#{t :translation_correct}:</b> #{@card.translated_text}<br />
                         <b>#{t :text_typed}:</b> #{params[:card][:translated_text]}<br /><br />
                         #{t :take_new_card}"
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
