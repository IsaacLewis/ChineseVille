class String
  def add_newlines(escape)
    gsub(escape,escape+"\r\n")
  end

  def add_breaks(escape)
    gsub(escape,escape+"<br />")
  end

  def scaling
    max_box_length = 10
    return 150 if length <= max_box_length
    overflow = length - max_box_length
    [100,150 - overflow * 5].max
  end
end
