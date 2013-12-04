require 'nokogiri'
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

module BioCWriter
  module_function
  def write(collection) 
    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      write_collection(xml, collection)
    end
    builder.to_xml
  end

  def write_infon(xml, obj)
    obj.infons.each do |k, v| 
      xml.infon(:key => k) {
        xml.text v
      }
    end
  end

  def write_collection(xml, collection)
    xml.collection {
      xml.source collection.source
      xml.date collection.date
      xml.key collection.key
      write_infon(xml, collection)
      collection.documents.each{|d| write_document(xml, d)}
    }
  end

  def write_document(xml, document)
    xml.document {
      xml.id_ document.id
      write_infon(xml, document)
      document.passages.each{|p| write_passage(xml, p)}
      document.relations.each{|r| write_relation(xml, r)}
    }
  end

  def write_passage(xml, passage)
    xml.passage {
      write_infon(xml, passage)
      xml.offset passage.offset
      xml.text_ passage.text unless passage.text.nil?
      passage.sentences.each{|s| write_sentence(xml, s)}
      passage.annotations.each{|a| write_annotation(xml, a)}
      passage.relations.each{|r| write_relation(xml, r)}
    }
  end

  def write_sentence(xml, sentence)
    xml.sentence {
      write_infon(xml, sentence)
      xml.offset sentence.offset
      xml.text_ sentence.text unless sentence.text.nil?
      sentence.annotations.each{|a| write_annotation(xml, a)}
      sentence.relations.each{|r| write_relation(xml, r)}
    }
  end

  def write_annotation(xml, annotation) 
    if annotation.id.nil?
      attribute = nil
    else
      attribute = {id: annotation.id}
    end
    xml.annotation(attribute) {
      write_infon(xml, annotation)
      xml.text_ annotation.text
      annotation.locations.each{|l| write_location(xml, l)}
    }
  end

  def write_relation(xml, relation) 
    if relation.id.nil?
      attribute = nil
    else
      attribute = {id: relation.id}
    end
    xml.relation(attribute) {
      write_infon(xml, relation)
      relation.nodes.each{|n| write_node(xml, n)}
    }
  end

  def write_location(xml, location) 
    xml.location(:offset => location.offset, :length => location.length)
  end

  def write_node(xml, node)
    xml.node_(:refid => node.refid, :role => node.role)
  end
end