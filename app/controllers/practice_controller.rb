class FlashcardController < ApplicationController
  before_filter :check_energy

  def flashcard
    @flashcard = Flashcard.next :user => @user, :exclude => @last_flashcard
    @possible_answers = @flashcard.possible_answers
  end

  def answer
    @last_answer = Word.find params[:answer_id]
    @last_flashcard = Flashcard.find params[:question_id]
    @correct = @last_flashcard.check_answer @last_answer
    @user.reload
    flashcard
    render :flashcard
  end

end
