module SimpleBioC
  class Node
    attr_accessor :refid, :role
    attr_reader :ref, :relation

    def initialize(parent)
      @relation = parent
    end

    def adjust_ref
      @ref = @relation.document.find_node(@refid)
    end

    def to_c
      "Node @#{@refid}: #{@role})"
    end
  end
end