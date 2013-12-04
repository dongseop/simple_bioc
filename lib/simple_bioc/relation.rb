require 'simple_bioc/node_base'

class Relation < NodeBase
  attr_accessor :nodes

  def initialize(parent)
    super(parent)
    @nodes = []
  end

  def adjust_ref
    nodes.each{|n| n.adjust_ref}
  end
end