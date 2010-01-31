$KCODE = 'u'
require 'jcode'
require 'rubygems'
require 'hpricot'

$file = File.new "/home/isaac/npcr.txt"
# $line = $file.readline

def parse(line)
  character, line = line.chomp.split "\t"
  pinyin, line = line.split "<br>"
  pinyin = pinyin.strip_tags
  english = line.split('<br />')[0..2].join.strip_tags
  english.gsub! /[㊀㊁㊂]/, ';'
  english.gsub! /^[; ]+/, ''
  english.gsub! /[; ]+$/, ''
  return character, pinyin, english
end

def parse_file(file)
  position = 0
  file.each_line do |line|
    character, pinyin, english = parse(line)
    unless character =~ /[A-z]/
      puts "Char: #{character} Pinyin: #{pinyin} English: #{english}"
      position += 1
      Word.create :english => english,
      :pinyin => pinyin,
      :character => character,
      :position => position,
      :word_list_id => 1
    end
  end
end

class String
  def strip_tags
    Hpricot(self).inner_text
  end

  def strip_non_ascii
    self.sub /[^A-z ]/, ''
  end
end

def user_confirm?(prompt='OK?')
  print prompt + ' '
  gets =~ /^[Yy]/
end
