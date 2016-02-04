module SimpleBioC
  class Location
    attr_accessor :offset, :length #, :original_offset
    attr_reader :annotation

    def initialize(parent)
      @offset = 0
      # @original_offset = 0
      @length = 0
      @annotation = parent
    end

    def to_s
      "Location @#{offset}:#{length}"
    end
  end
end