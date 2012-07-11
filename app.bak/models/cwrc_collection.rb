
class CwrcCollection < ActiveFedora::Base
  
  has_relationship "members", :is_member_of, :inbound => true
  
  has_relationship "member_of", :is_member_of
  
  has_many :items, :property=>:has_derivation
  has_many :subcollections, :property=>:has_collection
  
  has_metadata :name => "ccmContentMetadata", :type=> CcmContentDatastream
  
  def add_to_collection(collectionIDs)
    collectionIDs.each do |id|
      c = CwrcCollection.find(id)
      member_of_append(c)
    end
  end
  
  def remove_from_collection(collectionIDs)
    collectionIDs.each do |id|
      c = CwrcCollection.find(id)
      member_of_remove(c)
    end
  end
  
#
#  def get_child_collections(recurse = false, result = nil)
#    
#    result = Array.new if result.nil?
#    
#    members.each do |c|
#      if c.is_a?(CwrcCollection)
#        if recurse
#          already_traversed = result.any?{|i| i == c}
#
#          if !already_traversed
#            result.push(c)
#            result = c.get_child_collections(true, result)
#          end
#        else
#          result.push(c)
#        end
#      end #End: if c.is_a?(CwrcCollection)
#    end #End: members.each do |c|
#    
#    return result
#  end
#
  
  def get_children(retCollectionsOnly = false, recurse = false, result = nil)
    
    result = Array.new if result.nil?
    
    members.each do |x|
      already_traversed = result.any?{|i| i == x}
      if x.is_a?(CwrcCollection)
        if recurse
          unless already_traversed
            result.push(x)
            result = x.get_children(retCollectionsOnly, true, result)
          end
        else
          result.push(x) unless already_traversed
        end
      else #Else: if c.is_a?(CwrcCollection)
        unless retCollectionsOnly
          result.push(x) unless already_traversed
        end
      end #End: if c.is_a?(CwrcCollection)
    end #End: members.each do |c|
    
    return result
  end
  
  
  
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
  
#  def link_item(itemId)
#    
#    subject = itemId
#    predicate = "isMemberOf"
#    object = pid
#    url = $FEDORA + "/objects/#{itemId}/relationships/new?subject=#{subject}&predicate=#{predicate}&object=#{object}&isLiteral=true"
#    uri = URI.parse(url)
#    params = {}
#    x = Net::HTTP.post_form(uri, params)
#    
#    puts x.class
#    
#    #child = CwrcItem.find(itemId)
#    #child.add_relationship(:has_derivation, self)
#    #child.save
#  end
#  
#  def unlink_item(itemId)
#    child = CwrcItem.find(itemId)
#    child.remove_relationship(:has_derivation, self)
#    child.save
#  end
#  
#  def link_subcollection(subCollectionId)
#    child = CwrcCollection.find(subCollectionId)
#    child.add_relationship(:has_collection, self)
#    child.save
#  end
#  
#  def unlink_subcollection(subCollectionId)
#    child = CwrcCollection.find(subCollectionId)
#    child.remove_relationship(:has_collection, self)
#    child.save
#  end

end
