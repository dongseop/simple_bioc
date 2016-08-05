module SimpleBioC
  class Passage
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
      "Passage @#{@offset}: #{@text}"  
    end

    def find_node(id)
      (@relations+@annotations).each{|n| return n if n.id == id}
      @sentences.each do |s|
        ret = s.find_node(id)
        return ret unless ret.nil?
      end
      nil
    end

    def each_relation
      @relations.each{|r| yield r}
      @sentences.each{|s| s.each_relation{|r| yield r}}
    end

    def all_texts
      return text unless self.text.nil?
      @sentences.map{|s| s.text}.join(" ")
    end

    def all_annotations(ret)
      @annotations.each{|a| ret << a}
      @sentences.each{|s| s.all_annotations(ret)}
    end

    def all_relations(ret)
      @relations.each{|r| ret << r}
      @sentences.each{|s| s.all_relations(ret)}
    end
  end
end