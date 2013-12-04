class Location
  attr_accessor :offset, :length
  attr_reader :annotation

  def initialize(parent)
    @infons = {}
    @locations = []
    @annotation = parent
  end
end