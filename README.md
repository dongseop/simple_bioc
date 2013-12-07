# SimpleBioc

SimpleBioC is a simple parser / builder for BioC data format. BioC is a simple XML format to share text documents and annotations. You can find more information about BioC from the official BioC web site ([http://www.ncbi.nlm.nih.gov/CBBresearch/Dogan/BioC/](http://www.ncbi.nlm.nih.gov/CBBresearch/Dogan/BioC/))

## Feature:

 * Parse & convert a BioC document to an object instance compatible to BioC DTD
 * Use plain ruby objects for simplicity
 * Build a BioC document from an object instance
 
## Installation

Add this line to your application's Gemfile:

    gem 'simple_bioc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_bioc

## Usages

Include library

    require 'simple_bioc'
  
  
Parse with a file name (path)

    collection = SimpleBioC::from_xml(filename)
  
Traverse & Manipulate Data. Data structure are almost the same as the DTD. Please refer [library documents]() & [the BioC DTD](http://www.ncbi.nlm.nih.gov/CBBresearch/Dogan/BioC/BioCDTD.html).

    puts collection.documents[2].passages[0].text
  
Build XML text from data

    puts SimpleBioC::to_xml(collection)
  
## Sample

More samples can be found in Samples directory

    require 'simple_bioc'

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## LICENSE

Copyright © 2013, Dongseop Kwon

Released under the MIT License.
