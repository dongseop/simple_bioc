require 'simple_bioc/node_base'
module SimpleBioC
  class Relation < NodeBase
    attr_accessor :nodes

    def initialize(parent)
      super(parent)
      @nodes = []
    end

    def adjust_ref
      nodes.each{|n| n.adjust_ref}
    end

    def to_c
      "Relation:#{id}"
    end
  end
end