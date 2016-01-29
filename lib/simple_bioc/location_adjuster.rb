module SimpleBioC
  module LocationAdjuster
    def adjust_annotation_offsets
      obj = self
      return if obj.nil?
      obj.annotations.each do |a|
        positions = find_all_locations(obj, a.text)
        a.locations.each do |l|
          l.original_offset = l.offset.to_i if l.original_offset.nil?
          l.offset = choose_offset_candidate(l.offset, positions)
        end
      end
    end
    
    module_function

    def find_all_locations(obj, text)
      positions = []
      return positions if obj.nil? || obj.text.nil?
      pos = obj.text.index(text)
      until pos.nil? 
        positions << (pos + obj.offset)
        pos = obj.text.index(text, pos + 1)
      end
      return positions
    end

    def choose_offset_candidate(offset, positions)
      min_diff = 99999
      offset = offset.to_i
      ret = offset
      positions.each do |p|
        diff = (offset - p).abs
        if diff < min_diff
          ret = p 
          min_diff = diff
        end
      end
      return ret
    end
  end
end