require 'simple_bioc/location_adjuster'
module SimpleBioC
  class Passage
    include LocationAdjuster

    attr_accessor :offset, :text, :infons, :sentences, :annotations, :relations
    attr_reader :document

    def initialize(parent)
      @infons = {}
      @sentences = []
      @annotations = []
      @relations = []
      @document = parent
    end

    def to_s
      "Passage @#{offset}: #{text}"  
    end

    def find_node(id)
      (relations+annotations).each{|n| return n if n.id == id}
      sentences.each do |s|
        ret = s.find_node(id)
        return ret unless ret.nil?
      end
      nil
    end

    def each_relation
      relations.each{|r| yield r}
      sentences.each{|s| s.each_relation{|r| yield r}}
    end
  end
end