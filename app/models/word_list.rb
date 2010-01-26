class WordList < ActiveRecord::Base
  has_many :words
  has_many :users
end
