class User < ActiveRecord::Base
  has_one :village
  belongs_to :current_list, :class_name => "WordList"
  has_many :flashcards
  has_many :words, :through => :flashcards
  has_many :tests, :through => :flashcards

  validates_uniqueness_of :name

  MaxFlashcards = 12
  MinFlashcards = 10
  MaxEnergy = 20
  EnergyTick = 600

  def self.seconds_to_next_energy
    User::EnergyTick - (Time.now.to_i % User::EnergyTick)
  end

  def admin?
    id == 1
  end

  def add_energy
    bounded_update :energy, +1, MaxEnergy
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

  def next_flashcard(options={})
    if needs_more_flashcards?
      begin
        make_more_flashcards
      rescue ActiveRecord::RecordNotFound
        # if user has learned all the words, just give them
        # a random flashcard
        if unlearned_flashcards.empty?
          return flashcards.rand
        else
          return unlearned_flashcards.rand
        end
      end
    elsif has_due_flashcards?
      return due_flashcards.first
    else
      unlearned_flashcards.remove(options[:exclude]).rand
    end
  end

  def needs_more_flashcards?
    unlearned_flashcards.count < MinFlashcards
  end

  def learned_flashcards
    flashcards.all :conditions => 
      {:knowledge_chance => Flashcard::LearningThreshold..100}
  end

  def unlearned_flashcards
    flashcards.all :order => "knowledge_chance DESC",
    :conditions => {:knowledge_chance => 0...Flashcard::LearningThreshold}
  end

  def due_flashcards
    flashcards.all :order => :next_due,
    :conditions => {:next_due => (100.years.ago)..Time.now}
  end

  def due_flashcards_count
    Flashcard.count :conditions => 
      {:user_id => self.id,:next_due => (100.years.ago)..Time.now}
  end

  def has_due_flashcards?
    due_flashcards_count > 0
  end

  def learned_words
    Flashcard.count :conditions => 
      {:user_id => self.id, 
      :knowledge_chance => (Flashcard::LearningThreshold..100)}
  end

  def set_list(list_id)
    update_attribute :current_list_id, list_id
  end
end
