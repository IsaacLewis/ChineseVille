class Word < ActiveRecord::Base
  has_many :flashcards
  has_many :users, :through => :flashcards
  belongs_to :word_list

  def no_tone
    pinyin.gsub /[0-9]/, ''
  end

  def tone_number
    pinyin
  end

  def html_bg_colour
    'dc6666'
  end
end
