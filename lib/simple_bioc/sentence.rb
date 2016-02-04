require 'simple_bioc/location_adjuster'
module SimpleBioC
  class Sentence
    include LocationAdjuster

    attr_accessor :offset, :text, :infons, :annotations, :relations
    attr_reader :passage

    def initialize(parent)
      @infons = {}
      @annotations = []
      @relations = []
      @passage = parent
    end

    def find_node(id)
      (@relations+@annotations).each{|n| return n if n.id == id}
      nil
    end

    def each_relation
      @relations.each{|r| yield r}
    end

    def to_c
      "Sentence @#{@offset}: #{@text}"
    end
  end
end