class User < ActiveRecord::Base
  has_one :village
  has_many :flashcards
  has_many :words, :through => :flashcards
  has_many :tests, :through => :flashcards

  validates_uniqueness_of :name

  MaxFlashcards = 12
  MinFlashcards = 10

  def admin?
    id == 1
  end

  def add_energy
    bounded_update :energy, +1, 30
  end

  def buildables
    return [] unless has_village?
    village.buildables
  end

  def can_build?(building_type)
    building_type.word_ids_required.each do |word_id|
      flashcard = Flashcard.first :conditions => 
        {:word_id => word_id, :user_id => self.id}
      return false if flashcard.nil? or !flashcard.learned?
    end
    return true
  end

  def village_unlocked?
    can_build? BuildingType.first_where :name => 'Hut'
  end

  def has_village?
    !village.nil?
  end

  def make_more_flashcards
    while needs_more_flashcards?
      max_word_id = flashcards.map {|f| f.word_id}.max
      begin
        new_word = Word.find((max_word_id || 0) + 1)
      rescue ActiveRecord::RecordNotFound
        raise
      end
      flashcards.create :word_id => new_word.id, 
        :correct_tests => 0, 
        :incorrect_tests => 0, 
        :knowledge_chance => 0
    end
  end

  def next_flashcard(options)
    if needs_more_flashcards?
      begin
        make_more_flashcards
      rescue ActiveRecord::RecordNotFound
        # if user has learned all the words, just give them
        # a random flashcard
        return flashcards.rand if unlearned_flashcards.count < 2
      end
    end
    unlearned_flashcards.remove(options[:exclude]).rand
  end

  def needs_more_flashcards?
    unlearned_flashcards.count < MinFlashcards
  end

  def learned_flashcards
    flashcards.select {|f| f.learned?}
  end

  def unlearned_flashcards
    flashcards.select {|f| not f.learned?}
  end

  def learned_words
    Flashcard.count :conditions => 
      {:user_id => self.id, :knowledge_chance => (80..100)}
  end
end
