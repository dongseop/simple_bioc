module SimpleBioC
  class Collection
    attr_accessor :documents, :infons, :source, :date, :key

    def initialize
      @documents = []
      @infons = {}
      @source = ""
      @date = ""
      @key = ""
    end

    def to_c
      "Collection(source: #{source}, date: #{date}, key: #{key})"
    end
  end
end