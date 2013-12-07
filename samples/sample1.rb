# Sample1: parse, traverse, manipulate, and build BioC data
require 'simple_bioc'

# parse BioC file
collection = SimpleBioC.from_xml("../xml/everything.xml")

# the returned object contains all the information in the BioC file
# traverse & read information
collection.documents.each do |document|
  puts document
  document.passages.each do |passage|
    puts passage
  end
end

# manipulate 
doc = SimpleBioC::Document.new(collection)
doc.id = "23071747"
doc.infons["journal"] = "PLoS One"
collection.documents << doc

p = SimpleBioC::Passage.new(doc)
p.offset = 0
p.text = "TRIP database 2.0: a manually curated information hub for accessing TRP channel interaction network."
p.infons["type"] = "title"
doc.passages << p


# build BioC document from data
xml = SimpleBioC.to_xml(collection)
puts xml