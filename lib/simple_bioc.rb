# @author Dongseop Kwon
require "simple_bioc/version"
require "simple_bioc/bioc_reader"
require "simple_bioc/bioc_writer"

# SimpleBioC main library
module SimpleBioC
  module_function

  # parse a BioC XML file in the given path and convert it into a collection instance
  def from_xml(file_path)
    BioCReader.read(file_path)
  end

  # convert a collection instance to a BioC XML text
  def to_xml(collection)
    BioCWriter.write(collection)
  end
end
