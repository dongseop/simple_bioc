require 'simple_bioc/node_base'

class Annotation < NodeBase
  attr_accessor :locations, :text

  def initialize(parent)
    super(parent)

    @locations = []
  end
end