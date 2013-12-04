class Document
  attr_accessor :id, :infons, :passages, :relations
  attr_reader :collection

  def initialize(parent)
    @infons = {}
    @passages = []
    @relations = []
    @collection = parent
  end

  def find_node(id)
    relations.each{|r| return r if r.id == id}
    passages.each do |p|
      ret = p.find_node(id)
      return ret unless ret.nil?
    end
    nil
  end

  def adjust_ref
    each_relation{|r| r.adjust_ref}
  end

  def each_relation
    relations.each{|r| yield r}
    passages.each{|p| p.each_relation{|r| yield r}}
  end
end