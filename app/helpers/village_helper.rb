module VillageHelper
  def seconds_to_next_population
    secs_in_day = 24 * 60 * 60
    secs_in_day - (Time.now.to_i % secs_in_day)
  end
end
