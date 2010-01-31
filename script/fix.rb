ws = Word.all.select {|w| not w.english =~ /^[A-z0-9 ;()?,.'\/]+$/}


ws.each do |w|
  puts w.character
  puts w.pinyin
  puts w.english
  print '? '
  i = gets.chomp
  next if i.blank?
  w.update_attribute :english, i
end
