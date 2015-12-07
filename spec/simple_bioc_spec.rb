require 'simple_bioc'
require 'test_xml/spec'
describe "Simple function" do
  it "should have a DTD declaration" do
    collection = SimpleBioC.from_xml("./xml/everything.xml")
    output = SimpleBioC.to_xml(collection)
    expect(output).to include('<!DOCTYPE collection SYSTEM "BioC.dtd">')
  end
  
  it "should no space when save_with = 0" do
    collection = SimpleBioC.from_xml("./xml/everything.xml")
    output = SimpleBioC.to_xml(collection, {save_with: 0})
    expect(output).to include('<collection><source>Made up file to test that everything is allowed and processed. Has text in the passage.</source><date>20130426</date><key>everything.key</key><infon key="collection-infon-key">collection-infon-value</infon><document><id>1</id><infon key="document-infon-key">document-infon-value</infon><passage><infon key="passage-infon-key">passage-infon-value</infon><offset>0</offset><text>text of passage</text><annotation id="P1"><infon key="annotation-infon-key">annotation-infon-value</infon><location offset="1" length="2"/><text>annotation text</text></annotation><relation id="RP1"><infon key="passage-relation-infon-key">passage-relation-infon-value</infon><node refid="RP1" role="passage-relation"/></relation></passage><relation id="D1"><infon key="document-relation-infon-key">document-relation-infon-value</infon><node refid="RD1" role="document-relation"/></relation></document></collection>')
  end

  it "should process only one document by options" do
    collection = SimpleBioC.from_xml("./xml/lemma.xml", {documents:[21785578, 21488974]})
    output = SimpleBioC.to_xml(collection, {save_with: 0})
    expect(output.scan("<document>").size).to eq(2)
    expect(output).to include("<document><id>21785578</id>")
    expect(output).to include("<document><id>21488974</id>")
    expect(output).not_to include("<document><id>21660417</id>")
    expect(output).not_to include("<document><id>21951408</id>")
  end

  it "should have location node followed by text node" do
    collection = SimpleBioC.from_xml("./xml/everything.xml")
    output = SimpleBioC.to_xml(collection, {save_with: 0})
    expect(output).to include('<location offset="1" length="2"/><text>annotation text</text>')
  end

  it "should read bioc from file" do    
    f = File.open("./xml/everything.xml")
    collection = SimpleBioC.from_xml_file(f)
    f.close
    output = SimpleBioC.to_xml(collection)
    expect(output).to include('<!DOCTYPE collection SYSTEM "BioC.dtd">')
  end

  it "should read bioc from string" do    
    f = File.open("./xml/everything.xml")
    contents = f.read
    collection = SimpleBioC.from_xml_file(contents)
    f.close
    output = SimpleBioC.to_xml(collection)
    expect(output).to include('<!DOCTYPE collection SYSTEM "BioC.dtd">')
  end
end