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

  it "should fix location problem" do
    col1 = SimpleBioC.from_xml("./xml/merge/10366597_error.xml")
    output = SimpleBioC.to_xml(col1)
    File.write("./xml/merge/output_10366597.xml", output)
    col5 = SimpleBioC.from_xml("./xml/merge/output_10366597.xml")
  end 
end