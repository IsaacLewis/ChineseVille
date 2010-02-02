class Flashcard < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  add_methods_of :word
  has_many :tests, :class_name => "FlashcardTest"

  validates_presence_of :word_id, :user_id, :correct_tests, :incorrect_tests, 
  :knowledge_chance
  validates_inclusion_of :knowledge_chance, :in => 0..100

  LearningThreshold = 80
  
  def efactor; read_attribute(:efactor).to_f; end

  def hint_types
    case knowledge_chance
    when (0..19) then [:character, :pinyin, :english]
    when (20..39) then [:character, nil, :english]
    when (40..59) then [:character, :english, :pinyin]
    else [:english, :pinyin, :character]
    end
  end

  def current_word_list
    return nil if current_list.nil?
    WordList.find current_list
  end

  def hint1_type; hint_types[0]; end

  def hint2_type; hint_types[1]; end

  def answer_type; hint_types[2]; end

  def hint1; word.send(hint1_type); end

  def hint2 
    return '' if hint2_type.nil?
    word.send(hint2_type)
  end

  def answer; word.send(answer_type); end

  def show(display_type)
    word.send(display_type)
  end

  def possible_answers
    possible_answers = user.flashcards.remove(self).shuffle!.take 9
    possible_answers << self
    possible_answers.shuffle!
  end

  def update_due_date(q)
    # if the character hasn't been learned, or doesn't have a 
    # next due date, we won't start scheduling it for SRS yet
    return unless learned? or !next_due.nil?
    if last_interval.nil? or q < 3
      new_interval = 0.5 * q
    else
      new_interval = [last_interval * efactor, 1].max
    end
    new_efactor = efactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    update_attribute :next_due, Time.now + new_interval.days
    update_attribute :last_interval, new_interval
    update_attribute :efactor, [new_efactor, 1.3].max
  end

  def check_answer(answer)
    correct = (self.word_id == answer.id)
    if correct
      message = correct_answer_update
    else
      message = wrong_answer_update
    end
    tests.create :answer_id => answer.id
    return correct, message
  end

  def correct_answer_update
    user.unbounded_update :food, +3 unless learned? or recently_answered_correctly?
    user.bounded_update :energy, -1, 0
    unbounded_update :correct_tests, +1
    'Correct!' + user.energy.to_s + ' ' + user.food.to_s
  end

  def wrong_answer_update
    msg = wrong_answer_message # needs to be up here as it may change later
    bounded_update :knowledge_chance, -23, 0
    unbounded_update :incorrect_tests, +1
    user.bounded_update :energy, -1, 0
    update_due_date 0
    msg
  end

  def wrong_answer_message
    "Incorrect: the #{answer_type} for " +
      "<b>#{hint1}</b>/<b>#{hint2}</b> is <b>#{answer}</b>."
  end

  def rate_difficulty(rating)
    previously_learned = learned?
    previously_buildable = user.buildables
    case rating
      when "easy"
        bounded_update :knowledge_chance, +43, 100
        update_due_date 5
      when "medium"
        bounded_update :knowledge_chance, +23, 100
        update_due_date 4
      when "hard"
        bounded_update :knowledge_chance, +8, 100
        update_due_date 3
    end
    
    message = ''
    if not previously_learned and learned?
        message += " You have mastered the word #{self.character}!"
    end

    buildings_unlocked = user.buildables - previously_buildable
    buildings_unlocked.each do |building|
      message += " You have unlocked #{building.name.downcase.pluralize}!"
    end
    message
  end

  def learned?
    knowledge_chance > LearningThreshold
  end

  def recently_answered_correctly?
    recent_tests = tests.where :created_at => (((Time.now) - 10.minutes)..Time.now)
    recent_tests.each {|t| return true if t.correct?}
    false
  end

  def last_studied
    last_test = tests.first :order => "created_at DESC"
    return "never" if last_test.nil?
    (Time.now - last_test.created_at).to_approximate_duration + " ago"
  end

  def due_in
    return '' if next_due.nil?
    if next_due < Time.now
      (Time.now - next_due).to_approximate_duration + ' ago'
    else
      'in ' + (next_due - Time.now).to_approximate_duration
    end
  end

  def young?
    created_at < Time.now - 1.day
  end

  # ranges from 220 to 120
  def html_red
    (220 - (knowledge_chance * 1)).to_i.to_s 16
  end

  # ranges from 102/'66' to 187/'bb'
  def html_green
    green = (102 + (knowledge_chance * 0.85)).to_i.to_s 16
  end

  def html_blue
    '66'
  end

  def html_bg_colour
    html_red + html_green + html_blue
  end

  def html_text_colour
    [html_red,html_green,html_blue].map {|h| (h.hex - 70).to_s 16}.join   
  end
end
