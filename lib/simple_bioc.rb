require "simple_bioc/version"
require "simple_bioc/bioc_reader"
require "simple_bioc/bioc_writer"

module SimpleBioC
  module_function
  def from_xml(file_path)
    BioCReader.read(file_path)
  end

  def to_xml(collection)
    BioCWriter.write(collection)
  end
end
