class FlashcardController < ApplicationController
  before_filter :check_word_list, :check_energy
  skip_before_filter :check_word_list, :only => [:select_list]

  def select_list
    @user.set_list params[:list_id]
    test
    render :test
  end

  def test
    # FacebookerPublisher.deliver_news_feed(@fbuser, "Testing", "Hello, world")

    @flashcard = @user.next_flashcard :exclude => @flashcard # can't have the same flashcard twice
    render :choose_list and return if @flashcard.nil?    
    @possible_answers = @flashcard.possible_answers
    @answer_type = @flashcard.answer_type
  end

  def answer
    @last_answer = Word.find params[:answer_id]
    @flashcard = Flashcard.find params[:question_id]
    @correct_answer_id = @flashcard.word.id
    @correct, @answer_message, @last_reward = @flashcard.check_answer @last_answer
    @user.reload
    if @correct
      respond_to do |format|
        format.html {render 'rate_difficulty'}
        format.fbml {render 'rate_difficulty'}
        format.js {render :template => 'flashcard/correct_answer.js.erb'}
      end
    elsif @user.energy > 0
      test
      respond_to do |format|
        format.html {render 'test'}
        format.fbml {render 'test'}
        format.js {render :template => 'flashcard/wrong_answer.js.erb'}
      end
    else
      respond_to do |format|
        format.html {render 'no_energy'}
        format.fbml {render 'no_energy'}
        format.js {render :template => 'flashcard/no_energy.js.erb'}
      end
    end
  end

  def submit_difficulty_rating
    @flashcard = Flashcard.find params[:flashcard_id]
    test and render :test if @flashcard.nil?
    @correct = true
    @answer_message = @flashcard.rate_difficulty params[:rating]
    test
    respond_to do |format|
      format.html {render 'test'}
      format.fbml {render 'test'}
      format.js {render :template => 'flashcard/submit_rating.js.erb'}
    end
  end

  def no_energy
  end

  private

  def check_word_list
    @list = @user.current_list
    render :choose_list and return if @list.nil?
  end

  def check_energy
    render :no_energy and return if @user.energy <= 0
  end
end
