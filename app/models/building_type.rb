class BuildingType < ActiveRecord::Base
  has_many :buildings
  has_attached_file :image, :styles => {:thumb => "100x100#"}

  def word_ids_required
    eval(read_attribute :words_required)
  end

  def words_required
    word_ids_required.map {|word_id| Word.find word_id}
  end

  def flashcards_required(user)
    word_ids_required.map do |word_id|
      flashcard = Flashcard.first_where :word_id => word_id, :user_id => user.id
      if flashcard.nil? then Word.find word_id 
      else flashcard
      end
    end
  end
end
