$KCODE = 'u'
require 'jcode'
require 'rubygems'
require 'hpricot'

$file = File.new "/home/isaac/npcr.txt"
$line = $file.readline

def parse(line)
  character, line = line.chomp.split "\t"
  pinyin, line = line.split "<br>"
  pinyin = pinyin.strip_tags
  english = line.split("<br />").map {|d| d.strip_tags.strip_non_ascii.strip}
  return character, pinyin, english
end

class String
  def strip_tags
    Hpricot(self).inner_text
  end

  def strip_non_ascii
    self.sub /[^A-z ]/, ''
  end
end
