# print_annotation: print all annotations in the given file

require 'simple_bioc'

if ARGF.argv.size < 1
  puts "usage: ruby print_annotation.rb {filepath}"
  exit
end

collection = SimpleBioC::from_xml(ARGF.argv[0])
collection.documents.each do |d|
  d.passages.each do |p|
    p.sentences.each do |s|
      s.annotations.each{|a| puts "#{d} #{a}"}
    end
    p.annotations.each{|a| puts "#{d} #{a}"}
  end
end