
class CwrcItem < ActiveFedora::Base
  
  ##has_relationship "member_of", :is_member_of
  
  has_metadata :name => "ccmContentMetadata", :type=> CcmContentDatastream
  has_metadata :name => "workflowStamp", :type=> CcmContentDatastream
  
  def get_xml_description
    return datastreams["ccmContentMetadata"].get_xml_string
  end

  def replace_xml_description(xmlString)
    datastreams["ccmContentMetadata"].replace_xml_string(xmlString)
  end
  
  def add_stamp_string(xmlstring)
    
    new_stamp_doc = Nokogiri::XML::Document.parse(xmlstring)
    
    ds = datastreams["workflowStamp"]
    
    stamp_collection = ds.get_xml_element
    if stamp_collection.nil?
      stamp_collection = Nokogiri::XML::Document.parse("<Workflow-Stamp-Collection/>").root
    end
    
    stamp_wrapper = Nokogiri::XML::Document.parse("<Stamp-Container version='#{stamp_collection.elements.count + 1}'/>").root
    
    stamp_wrapper.add_child(new_stamp_doc.root)
    stamp_collection.add_child(stamp_wrapper)
    ds.replace_xml_element(stamp_collection)
  end
  
  def get_stamp_array
    stamp_container = datastreams["workflowStamp"].get_xml_element
    
    stamp_array = Array.new
    
    unless stamp_container.nil?
      stamp_container.elements.each do |wrapper|
        stamp_array[wrapper.get_attribute('version').to_i - 1] = wrapper.elements
      end
    end
    
    return stamp_array
  end
  
  def add_to_collection(collectionIDs)
    self.save unless self.new_object? ##Item should have a valid pid in order to add it to the collection using hasCollectionMember predicate
    
    collectionIDs.each do |id|
      c = CwrcCollection.find(id)
      
      self.add_relationship(:is_member_of_collection, c)
      
      c.add_relationship(:has_collection_member, self)
      c.save
    end
    self.save
  end
  
  def remove_from_collection(collectionIDs)
    collectionIDs.each do |id|
      c = CwrcCollection.find(id)
      
      self.remove_relationship(:is_member_of_collection, c)
      
      c.remove_relationship(:has_collection_member, self)
      c.save
    end
    self.save
  end
  

#  def to_solr(solr_doc=Hash.new)
#    super
#    solr_doc["object_type_facet"] = "CwrcContent"
#    return solr_doc
#  end
  
end
