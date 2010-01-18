class Numeric
  def add_plus
    self < 0 ? to_s : "+" + to_s
  end

  def to_approximate_duration
    secs = self.to_i
    return secs.to_s + " seconds" if secs < 60
    mins = secs / 60
    return mins.to_s + " minutes" if mins < 60
    hours = mins / 60
    return hours.to_s + " hours" if hours < 24
    days = hours / 24
    days.to_s + " days"
  end
end
