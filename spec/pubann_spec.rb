require 'simple_bioc'
require 'yajl'
require 'json-compare'
require 'test_xml/spec'

describe "PubAnn" do
  it "should convert file to pubann JSON" do
    col1 = SimpleBioC.from_xml("./xml/pubann/18034444.xml")
    output = SimpleBioC.to_pubann(col1, {
      sourcedb: 'PubMed', 
      target: 'http://pubannotation.org/docs/sourcedb/PubMed/sourceid/18034444', 
      project: 'Ab3P-abbreviations'
    })
    puts output
  end 
end