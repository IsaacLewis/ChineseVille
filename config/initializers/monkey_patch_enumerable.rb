module Enumerable
  def remove(element)
    reject {|x| x == element}
  end

  def remove!(element)
    reject! {|x| x == element}
  end
end
