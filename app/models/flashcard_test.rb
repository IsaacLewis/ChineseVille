class FlashcardTest < ActiveRecord::Base
  belongs_to :flashcard
  belongs_to :answer, :class_name => "Word"

  def correct?
    flashcard.word_id == answer.id
  end
end
