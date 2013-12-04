class Sentence
  attr_accessor :offset, :text, :infons, :annotations, :relations
  attr_reader :passage

  def initialize(parent)
    @infons = {}
    @annotations = []
    @relations = []
    @passage = parent
  end

  def find_node(id)
    (relations+annotations).each{|n| return n if n.id == id}
    nil
  end

  def each_relation
    relations.each{|r| yield r}
  end
end