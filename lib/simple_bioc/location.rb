module SimpleBioC
  class Location
    attr_accessor :offset, :original_offset, :length
    attr_reader :annotation

    def initialize(parent)
      @infons = {}
      @locations = []
      @annotation = parent
    end

    def to_s
      "Location @#{offset}:#{length}"
    end
  end
end