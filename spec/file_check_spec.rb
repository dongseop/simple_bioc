require 'simple_bioc'
require 'test_xml/spec'
describe "File Check" do
  it "should load XML files successfully" do
    Dir["./xml/*.xml"].each do |file_path|
      puts file_path
      collection = SimpleBioC.from_xml(file_path)
      output = SimpleBioC.to_xml(collection)
      expected = File.read(file_path)
      expect(output).to equal_xml(expected)
    end
  end

  it "should merge documents successfully" do
    col1 = SimpleBioC.from_xml("./xml/merge/9864355.xml")
    col2 = SimpleBioC.from_xml("./xml/merge/9864355_1.xml")
    col3 = SimpleBioC.from_xml("./xml/merge/9864355_2.xml")
    col4 = SimpleBioC.from_xml("./xml/merge/9864355_3.xml")

    SimpleBioC.merge(col1, col2)
    SimpleBioC.merge(col1, col3)
    SimpleBioC.merge(col1, col4)
    output = SimpleBioC.to_xml(col1)
    File.write("./xml/merge/output.xml", output)
  end 
end