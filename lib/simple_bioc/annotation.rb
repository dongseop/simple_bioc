require 'simple_bioc/node_base'
module SimpleBioC
  class Annotation < NodeBase
    attr_accessor :locations, :text

    def initialize(parent)
      super(parent)
      @locations = []
    end

    def to_s
      "Annotation:#{@id} #{@text}"
    end
  end
end