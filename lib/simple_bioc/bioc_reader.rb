require 'nokogiri'
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

module BioCReader
  module_function

  def read(path, options) 
    collection = nil
    File.open(path) do |file|
      collection = read_from_file_or_string(file, options)
    end

    collection
  end

  def read_from_file_or_string(file_or_string, options)
    collection = nil

    xml_doc  = Nokogiri::XML(file_or_string) do |config|
      config.noent.strict.noblanks
    end
    xml = xml_doc.at_xpath("//collection")
    if xml.nil?
      fail 'Wrong format'
    end
    collection = SimpleBioC::Collection.new
    read_collection(xml, collection, options)

    collection
  end

  def read_text(xml, name)
    node = xml.at_xpath(name)
    node && node.content
  end

  def read_int(xml, name)
    val = read_text(xml, name) 
    val && val.to_i
  end

  def read_infon(xml, obj)
    xml.xpath("infon").each{ |i| obj.infons[i["key"]] = i.content}
  end

  def read_recursive(xml, obj, name, options = {})
    target_class = SimpleBioC.const_get(name.capitalize)
    xml.xpath(name).each do |node|
      instance = target_class.new(obj)
      ret = send(:"read_#{name}", node, instance, options)
      obj.instance_variable_get(:"@#{name}s")  << instance if ret
    end
  end

  def read_collection(xml, collection, options = {})
    collection.source = read_text(xml, "source")
    collection.date = read_text(xml, "date")
    collection.key = read_text(xml, "key")
    read_infon(xml, collection)
    read_recursive(xml, collection, "document", options)
  end  

  def read_document(xml, document, options = {})
    document.id = read_text(xml, "id")
    if options[:documents].kind_of?(Array) && !options[:documents].include?(document.id)
      return false
    end
    read_infon(xml, document)
    read_recursive(xml, document, "passage")
    read_recursive(xml, document, "relation")
    document.adjust_ref
    true
  end

  def read_passage(xml, passage, options = {})
    passage.text = read_text(xml, "text")
    passage.offset = read_int(xml, "offset")
    read_infon(xml, passage)
    read_recursive(xml, passage, "sentence")
    read_recursive(xml, passage, "annotation")
    read_recursive(xml, passage, "relation")
    passage.adjust_annotation_offsets
    true
  end

  def read_sentence(xml, sentence, options = {})
    sentence.text = read_text(xml, "text")
    sentence.offset = read_int(xml, "offset")
    read_infon(xml, sentence)
    read_recursive(xml, sentence, "annotation")
    read_recursive(xml, sentence, "relation")
    sentence.adjust_annotation_offsets
    true
  end

  def read_annotation(xml, annotation, options = {}) 
    annotation.id = xml["id"]
    annotation.text = read_text(xml, "text")
    read_infon(xml, annotation)
    read_recursive(xml, annotation, "location")
    true
  end

  def read_relation(xml, relation, options = {}) 
    relation.id = xml["id"]
    read_infon(xml, relation)
    read_recursive(xml, relation, "node")
    true
  end

  def read_location(xml, location, options = {}) 
    location.offset = xml["offset"]
    location.length = xml["length"]
    location.original_offset = xml["original_offset"]
    true
  end

  def read_node(xml, node, options = {})
    node.refid = xml["refid"]
    node.role = xml["role"]
    true
  end
end