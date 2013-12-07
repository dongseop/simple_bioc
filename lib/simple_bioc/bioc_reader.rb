require 'nokogiri'
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

module BioCReader
  module_function

  def read(path) 
    collection = nil
    File.open(path) do |file|
      xml_doc  = Nokogiri::XML(file) do |config|
        config.noent.strict.noblanks
      end
      xml = xml_doc.at_xpath("//collection")
      if xml.nil?
        fail 'Wrong format'
      end
      collection = SimpleBioC::Collection.new
      read_collection(xml, collection)
    end

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

  def read_recursive(xml, obj, name)
    target_class = SimpleBioC.const_get(name.capitalize)
    xml.xpath(name).each do |node|
      instance = target_class.new(obj)
      send(:"read_#{name}", node, instance)
      obj.instance_variable_get(:"@#{name}s")  << instance
    end
  end

  def read_collection(xml, collection)
    collection.source = read_text(xml, "source")
    collection.date = read_text(xml, "date")
    collection.key = read_text(xml, "key")
    read_infon(xml, collection)
    read_recursive(xml, collection, "document")
  end  

  def read_document(xml, document)
    document.id = read_text(xml, "id")
    read_infon(xml, document)
    read_recursive(xml, document, "passage")
    read_recursive(xml, document, "relation")
    document.adjust_ref
  end

  def read_passage(xml, passage)
    passage.text = read_text(xml, "text")
    passage.offset = read_int(xml, "offset")
    read_infon(xml, passage)
    read_recursive(xml, passage, "sentence")
    read_recursive(xml, passage, "annotation")
    read_recursive(xml, passage, "relation")
  end

  def read_sentence(xml, sentence)
    sentence.text = read_text(xml, "text")
    sentence.offset = read_int(xml, "offset")
    read_infon(xml, sentence)
    read_recursive(xml, sentence, "annotation")
    read_recursive(xml, sentence, "relation")
  end

  def read_annotation(xml, annotation) 
    annotation.id = xml["id"]
    annotation.text = read_text(xml, "text")
    read_infon(xml, annotation)
    read_recursive(xml, annotation, "location")
  end

  def read_relation(xml, relation) 
    relation.id = xml["id"]
    read_infon(xml, relation)
    read_recursive(xml, relation, "node")
  end

  def read_location(xml, location) 
    location.offset = xml["offset"]
    location.length = xml["length"]
  end

  def read_node(xml, node)
    node.refid = xml["refid"]
    node.role = xml["role"]
  end
end