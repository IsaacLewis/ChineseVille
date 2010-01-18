module FlashcardHelper
  def seconds_to_next_energy
    360 - (Time.now.to_i % 360)
  end
end
