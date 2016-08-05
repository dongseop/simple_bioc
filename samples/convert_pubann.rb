# convert document to PubAnnotation JSON
require 'simple_bioc'

if ARGF.argv.size < 1
  puts "usage: ruby convert_pubann.rb {filepath}"
  exit
end

collection = SimpleBioC::from_xml(ARGF.argv[0])
puts SimpleBioC::to_pubann(collection, {
  sourcedb: 'PubMed', 
  target: 'http://pubannotation.org/docs/sourcedb/PubMed/sourceid/18034444', 
  project: 'Ab3P-abbreviations'
})