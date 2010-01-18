class Flashcard < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  add_methods_of :word
  has_many :tests, :class_name => "FlashcardTest"

  validates_presence_of :word_id, :user_id, :correct_tests, :incorrect_tests, 
  :knowledge_chance
  validates_inclusion_of :knowledge_chance, :in => 0..100

  def hint_types
    case knowledge_chance
    when (0..19) then [:character, :pinyin, :english]
    when (20..39) then [:character, nil, :english]
    when (40..59) then [:character, :english, :pinyin]
    else [:english, :pinyin, :character]
    end
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
    previously_learned = learned?
    previously_buildable = user.buildables
    user.unbounded_update :food, +3 unless learned? or recently_answered_correctly?
    bounded_update :knowledge_chance, +17, 100
    unbounded_update :correct_tests, +1

    message = 'Correct!'
    if not previously_learned and learned?
        message += " You have mastered the word #{character}!"
    end

    buildings_unlocked = user.buildables - previously_buildable
    buildings_unlocked.each do |building|
      message += " You have unlocked #{building.name.downcase.pluralize}!"
    end
    message
  end

  def wrong_answer_update
    bounded_update :knowledge_chance, -17, 0
    unbounded_update :incorrect_tests, +1
    user.bounded_update :energy, -1, 0
    wrong_answer_message
  end

  def wrong_answer_message
    "Incorrect: the #{answer_type} for " +
      "<b>#{hint1}</b>/<b>#{hint2}</b> is <b>#{answer}</b>."
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

  def learned?
    knowledge_chance > 80
  end
end
