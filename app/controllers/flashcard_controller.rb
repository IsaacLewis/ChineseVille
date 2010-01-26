class FlashcardController < ApplicationController
  before_filter :check_word_list, :check_energy
  skip_before_filter :check_word_list, :only => [:select_list]

  def select_list
    @user.set_list params[:list_id]
    test
    render :test
  end

  def test
    @flashcard = @user.next_flashcard :exclude => @last_flashcard
    @possible_answers = @flashcard.possible_answers
    @answer_type = @flashcard.answer_type
  end

  def answer
    @last_answer = Word.find params[:answer_id]
    @last_flashcard = Flashcard.find params[:question_id]
    @correct, @answer_message = @last_flashcard.check_answer @last_answer
    @user.reload
    test
    render :test
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
