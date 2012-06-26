
class CwrcCollection < ActiveFedora::Base
  
  has_relationship "members", :is_member_of, :inbound => true
  
  has_many :items, :property=>:has_derivation
  has_many :subcollections, :property=>:has_collection
  
  has_metadata :name => "ccmContentMetadata", :type=> CcmContentDatastream
  
  
  def get_xml_description
    return datastreams["ccmContentMetadata"].get_xml_string
  end

  def replace_xml_description(xmlString)
    return datastreams["ccmContentMetadata"].replace_xml_string(xmlString)
  end

#  def to_solr(solr_doc=Hash.new)
#    super
#    solr_doc["object_type_facet"] = "CwrcContent"
#    return solr_doc
#  end
  
 
  def self.get_latest_pids
    CwrcCollection.find(:all)
  end
  
  def link_item(itemId)
    
    subject = itemId
    predicate = "isMemberOf"
    object = pid
    url = $FEDORA + "/objects/#{itemId}/relationships/new?subject=#{subject}&predicate=#{predicate}&object=#{object}&isLiteral=true"
    uri = URI.parse(url)
    params = {}
    x = Net::HTTP.post_form(uri, params)
    
    puts x.class
    
    #child = CwrcItem.find(itemId)
    #child.add_relationship(:has_derivation, self)
    #child.save
  end
  
  def unlink_item(itemId)
    child = CwrcItem.find(itemId)
    child.remove_relationship(:has_derivation, self)
    child.save
  end
  
  def link_subcollection(subCollectionId)
    child = CwrcCollection.find(subCollectionId)
    child.add_relationship(:has_collection, self)
    child.save
  end
  
  def unlink_subcollection(subCollectionId)
    child = CwrcCollection.find(subCollectionId)
    child.remove_relationship(:has_collection, self)
    child.save
  end
end
