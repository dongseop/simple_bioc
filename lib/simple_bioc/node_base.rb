class NodeBase
  attr_accessor :id, :infons
  attr_reader :document, :passage, :sentence

  def initialize(parent)
    @infons = {}
    @document = parent if parent.is_a? Document
    @passage  = parent if parent.is_a? Passage
    @sentence = parent if parent.is_a? Sentence 

    @passage  = @sentence.passage unless @sentence.nil?
    @document = @passage.document unless @passage.nil?
  end
end