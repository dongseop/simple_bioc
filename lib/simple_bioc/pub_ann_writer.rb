require 'jbuilder'

Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

module PubAnnWriter
  module_function
  def write(collection, options = {})
    Jbuilder.new do |json|
      write_collection(json, collection, options)
    end.target!
  end

  def write_collection(json, collection, options)
    json.array! collection.documents do |d|
      write_document(json, d, options)
    end
  end

  def write_document(json, document, options)
    json.sourceid document.id
    json.sourcedb options[:sourcedb] || ""
    json.project options[:project] || ""
    json.target options[:target] || ""
    json.text document.all_texts
    json.denotations document.all_annotations do |a|
      a.locations.each do |l|
        json.span do 
          json.begin l.offset.to_i
          json.end l.offset.to_i + l.length.to_i
        end
        json.obj a.infons.map{|k,v| v}.join(",")
        json.id a.id unless a.id.nil?
      end
    end
    json.relations document.all_relations do |r|
      json.pred r.infons.map{|k,v| v}.join(",")
      first = true
      r.nodes.each do |n|
        if first 
          json.obj n.refid
          first = false
        else
          json.subj n.refid
        end
      end
      json.id r.id unless r.id.nil?
    end
  end
end