require 'simple_bioc'
require 'test_xml/spec'
describe "Simple function" do
  it "should have a DTD declaration" do
    collection = SimpleBioC.from_xml("./xml/everything.xml")
    output = SimpleBioC.to_xml(collection)
    output.should include('<!DOCTYPE collection SYSTEM "BioC.dtd">')
  end
  
  it "should no space when save_with = 0" do
    collection = SimpleBioC.from_xml("./xml/everything.xml")
    output = SimpleBioC.to_xml(collection, {save_with: 0})
    output.should include('<collection><source>Made up file to test that everything is allowed and processed. Has text in the passage.</source><date>20130426</date><key>everything.key</key><infon key="collection-infon-key">collection-infon-value</infon><document><id>1</id><infon key="document-infon-key">document-infon-value</infon><passage><infon key="passage-infon-key">passage-infon-value</infon><offset>0</offset><text>text of passage</text><annotation id="P1"><infon key="annotation-infon-key">annotation-infon-value</infon><text>annotation text</text><location offset="1" length="2"/></annotation><relation id="RP1"><infon key="passage-relation-infon-key">passage-relation-infon-value</infon><node refid="RP1" role="passage-relation"/></relation></passage><relation id="D1"><infon key="document-relation-infon-key">document-relation-infon-value</infon><node refid="RD1" role="document-relation"/></relation></document></collection>')
  end

  it "should process only one document by options" do
    collection = SimpleBioC.from_xml("./xml/lemma.xml", {documents:[21785578, 21488974]})
    output = SimpleBioC.to_xml(collection, {save_with: 0})
    output.scan("<document>").size.should equal 2
    output.should include("<document><id>21785578</id>")
    output.should include("<document><id>21488974</id>")
    output.should_not include("<document><id>21660417</id>")
    output.should_not include("<document><id>21951408</id>")
  end
end