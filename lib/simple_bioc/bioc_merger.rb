require 'nokogiri'

Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

module BioCMerger
  module_function

  def merge(dest_collection, src_collection)
    errors = []
    warnings = []
    id_map = {}

    if dest_collection.documents.size != 1 || src_collection.documents.size != 1
      warnings << 'Only the first documents will be merged'
    end

    doc_d = dest_collection.documents[0]
    doc_s = src_collection.documents[0]

    copy_infons(dest_collection, src_collection)
    dest_collection.source = src_collection.source if dest_collection.source.nil? || dest_collection.source.empty?
    dest_collection.date = src_collection.date if dest_collection.date.nil? || dest_collection.date.empty?
    dest_collection.key = src_collection.key if dest_collection.key.nil? || dest_collection.key.empty?

    copy_infons(doc_d, doc_s)
    copy_relations(doc_d, doc_d, doc_s, id_map)

    if doc_d.passages.size != doc_s.passages.size
      warnings << 'Passages will not be merged because the numbers of passages in documents are different'
    end

    doc_d.passages.each_with_index do |p_d, index|
      p_s = doc_s.passages[index]
      if p_d.nil? || p_s.nil?
        warnings << 'The number of sentences in pages should be the same'
      elsif blank?(p_d.text) && blank?(p_s.text) && p_d.sentences.size != p_s.sentences.size
        warnings << 'The number of sentences in pages should be the same'
      end
    end

    doc_d.passages.each_with_index do |p_d, index|
      p_s = doc_s.passages[index]
      next if p_d.nil? || p_s.nil?
      copy_relations(doc_d, p_d, p_s, id_map)
      if p_d.sentences.size == p_s.sentences.size
        p_d.sentences.each_with_index do |s_d, index|
          s_s = p_s.sentences[index]
          copy_infons(s_d, s_s)
          copy_text(s_d, s_s)
          copy_relations(doc_d, s_d, s_s, id_map)
          copy_annotations(doc_d, s_d, s_s, id_map)
          s_d.adjust_annotation_offsets
        end
      elsif p_d.sentences.size == 0
        p_d.text = p_s.sentences.map{|s| s.text}.join(" ") if blank?(p_d.text)
        p_s.sentences.each do |s|
          copy_relations(doc_d, p_d, s, id_map)
          copy_annotations(doc_d, p_d, s, id_map)
        end
      elsif p_s.sentences.size == 0
        if p_d.sentences.size > 0
          # dest has sentences, but src has only passages. 
          p_d.text = p_d.sentences.map{|s| s.text}.join(" ") if blank?(p_d.text)
          p_d.sentences.each do |s|
            s.annotations.each do |a|
              a.clear_sentence
              p_d.annotations << a
            end
            s.relations.each do |r|
              r.clear_sentence
              p_d.relations << r
            end
          end
          p_d.sentences.clear
        else
          copy_text(p_d, p_s)
        end
      end
      copy_annotations(doc_d, p_d, p_s, id_map)
      p_d.adjust_annotation_offsets
    end
    puts warnings
  end

  def adjust_relation_refids(doc, id_map)
    adjust_relation_refid(doc, id_map)
    doc.passages.each do |p|
      adjust_relation_refid(p, id_map)
      p.sentences.each do |s|
        adjust_relation_refid(s, id_map)
      end
    end
  end

  def adjust_relation_refid(obj, id_map) 
    return if obj.nil?
    obj.relations.each do |r|
      next if r.original.nil?
      r.nodes.each do |n|
        new_id = id_map[n.refid]
        n.refid = new_id unless new_id.nil?
        n.adjust_ref
      end
    end
  end

  def copy_relations(doc, dest, src, id_map)
    return if src.nil?
    src.relations.each do |r|
      copy_relation(doc, dest, r, id_map)
    end
  end

  def copy_annotations(doc, dest, src, id_map)
    return if src.nil?
    src.annotations.each do |a|
      copy_annotation(doc, dest, a, id_map)
    end
  end
  def copy_relation(doc, dest, relation, id_map)
    new_r = nil
    need_add = true
    dest.relations.each do |r|
      if r.id == relation.id
        new_r = r
        need_add = false
        break
      end
    end
    if new_r.nil?
      new_r = SimpleBioC::Relation.new(dest)
      new_r.id = choose_id(doc, relation.id, id_map)
      new_r.original = relation
    end

    relation.nodes.each do |n|
      found = false
      new_r.nodes.each do |old_n|
        if n.refid == old_n.refid && n.role == old_n.role
          found = true
          break
        end
      end
      unless found
        node = SimpleBioC::Node.new(new_r)
        node.refid = n.refid
        node.role = n.role
        new_r.nodes << node
      end
    end
    copy_infons(new_r, relation)
    if need_add 
      dest.relations << new_r
    end
  end

  def copy_annotation(doc, dest, annotation, id_map)
    new_a = nil
    need_add = true
    dest.annotations.each do |a|
      if a.id == annotation.id && a.text == annotation.text
        new_a = a
        need_add = false
        break
      end
    end
    if new_a.nil?
      new_a = SimpleBioC::Annotation.new(dest)
      new_a.id = choose_id(doc, annotation.id, id_map)
      new_a.text = annotation.text
      new_a.locations = []
    end

    annotation.locations.each do |l|
      found = false
      new_a.locations.each do |old_l|
        if l.offset == old_l.offset && l.length == old_l.length
          found = true
          break
        end
      end
      unless found
        new_l = SimpleBioC::Location.new(new_a)
        new_l.offset = l.offset
        new_l.length = l.length 
        new_a.locations << new_l
      end
    end
    copy_infons(new_a, annotation)
    if need_add
      dest.annotations << new_a
    end
  end

  def choose_id(doc, id, id_map) 
    new_id = id || "id"
    node = doc.find_node(new_id)

    until node.nil? do
      new_id = new_id + "_c"
      node = doc.find_node(new_id)
    end

    if new_id != id
      id_map[id] = new_id
    end
    return new_id
  end

  def copy_text(dest, src)
    if blank?(dest.text) && !blank?(src.text)
      dest.text = src.text
    end
  end

  def blank?(text)
    return text.nil? || text.empty?
  end

  def copy_infons(dest, src)
    src.infons.each do |k, v|
      if dest.infons[k].nil?
        dest.infons[k] = v
      elsif dest.infons[k] != v
        
      end
    end
  end
end