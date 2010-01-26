require 'test_helper'

class FlashcardUnitTest < ActiveSupport::TestCase
  def setup
    @u = users(:one)
  end

  def test_defaults
    new = Flashcard.create
    assert_equal 2.5, new.efactor
  end

  def test_learned_unlearned
    assert_equal @u.learned_flashcards.count + @u.unlearned_flashcards.count,
    @u.flashcards.count
  end
end
