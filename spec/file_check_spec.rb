require 'simple_bioc'
require 'test_xml/spec'
describe "File Check" do
  it "should be load successfully" do
    Dir["./xml/*.xml"].each do |file_path|
      puts file_path
      collection = SimpleBioC.from_xml(file_path)
      output = SimpleBioC.to_xml(collection)
      expected = File.read(file_path)
      expect(output).to equal_xml(expected)
    end
  end
end