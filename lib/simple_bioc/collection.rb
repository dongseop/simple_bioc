class Collection
  attr_accessor :documents, :infons, :source, :date, :key

  def initialize
    @documents = []
    @infons = {}
    @source = ""
    @date = ""
    @key = ""
  end

  def to_xml
    
  end
end