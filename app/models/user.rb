class User < ActiveRecord::Base
  has_one :village
  belongs_to :current_list, :class_name => "WordList"
  has_many :flashcards
  has_many :words, :through => :flashcards
  has_many :tests, :through => :flashcards

  MaxFlashcards = 12
  MinFlashcards = 10
  MaxEnergy = 30
  EnergyTick = 360

  def self.create_from(fb_user)
    new = create :name => fb_user.name, 
    :facebook_id => fb_user.facebook_id,
    :authentication => 'facebook',
    :energy => MaxEnergy * 2
    new.save
    new
  end

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
    learned_words >= building_type.words_required
  end

  def correct_answer_bonus
    bounded_update :combos, +1, 10
    if combos >= 10
      update_attribute :combos, 0
      bounded_update :energy, +3, 30
    end
  end

  def combo_image
    if (0..7).include? combos then "combo_#{combos}.png"
    else "combo_7.png"
    end
  end

  def village_unlocked?
    can_build? BuildingType.first_where :name => 'Hut'
  end

  def has_village?
    !village.nil?
  end

  def make_more_flashcards
    while needs_more_flashcards?
      position_in_list = flashcards.map {|f| f.position}.max
      position_in_list = 0 if position_in_list.nil?
      new_word = Word.first_where :position => position_in_list + 1,
      :word_list_id => current_list_id
      return if new_word.nil?
      flashcards.create :word_id => new_word.id
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
    end
    if has_due_flashcards?
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
    make_more_flashcards
  end

  def young?
    created_at > Time.now - 1.day
  end
end
