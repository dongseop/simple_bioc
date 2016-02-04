module SimpleBioC
  # NodeBase is not a BioC DTD entity. This is a super class of Annotation & Relation.
  class NodeBase
    attr_accessor :id, :infons
    attr_reader :document, :passage, :sentence

    def initialize(parent)
      @infons = {}
      @id = nil
      @document = parent if parent.is_a? Document
      @passage  = parent if parent.is_a? Passage
      @sentence = parent if parent.is_a? Sentence 
      @passage  = @sentence.passage unless @sentence.nil?
      @document = @passage.document unless @passage.nil?
    end

    def clear_sentence
      @sentence = nil
    end
  end
end