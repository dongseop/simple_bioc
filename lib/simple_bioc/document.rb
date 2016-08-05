module SimpleBioC
  class Document
    # attribute
    attr_accessor :id, :infons, :passages, :relations

    # parent 
    attr_reader :collection

    def initialize(parent)
      @infons = {}
      @passages = []
      @relations = []
      @collection = parent
    end

    def find_node(id)
      @relations.each{|r| return r if r.id == id}
      @passages.each do |p|
        ret = p.find_node(id)
        return ret unless ret.nil?
      end
      nil
    end

    def adjust_ref
      each_relation{|r| r.adjust_ref}
    end

    def each_relation
      @relations.each{|r| yield r}
      @passages.each{|p| p.each_relation{|r| yield r}}
    end

    def to_s
      "Document:#{@id}"
    end

    def all_texts
      @passages.map{|p| p.all_texts}.join(" ")
    end

    def all_annotations
      ret = []
      @passages.each{|p| p.all_annotations(ret)}
      ret
    end

    def all_relations
      ret = []
      @relations.each{|r| ret << r}
      @passages.each{|p| p.all_relations(ret)}
      ret
    end
  end
end