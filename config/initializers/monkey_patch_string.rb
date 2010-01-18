class String
  def add_newlines(escape)
    gsub(escape,escape+"\r\n")
  end

  def add_breaks(escape)
    gsub(escape,escape+"<br />")
  end
end
