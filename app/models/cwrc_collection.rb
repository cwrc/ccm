
# This class represents CWRC Collections. 

class CwrcCollection < CcmBase
  
  has_many :items, :property=>:has_derivation
  has_many :subcollections, :property=>:has_collection
  
  # Creates a new collection
  def initialize()
    super(:namespace=>"collection")
    self.type = "Collection"
  end
 
  # Sets collection name
  def name=(val)
    get_dc.title = val
  end
  
  # Returns collection name
  def name
    get_dc.title
  end
  
  # Sets collection owner
  def owner=(val)
    get_dc.creator = val
  end
  
  # Returns collection owner
  def owner
    get_dc.creator
  end  
  
  # Sets collection creation date forcefully
  def created=(val)
    get_dc.created = val
  end

  # Returns collection creation date
  def created
    get_dc.created
  end
  
  # Sets rights
  def rights=(val)
    get_dc.rights = val
  end
  
  # Returns rights
  def rights
    get_dc.rights
  end
  
  # Adds one or more new contributors to the collection.
  #
  # <b>Params</b>
  # * val: a comma-speatrated list of contributors 
  def add_contributor(val)
    get_dc.add_contributor(val.split(",").map{|x| x.strip}) unless val.nil?
  end
  
  # Returns the list of contributors of the collection as an array of strings 
  def get_contributors
    get_dc.contributors
  end
  
  # Adds one or more new languages to the collection
  #
  # <b>Params</b>
  # * val: a comma-speatrated list of languages 
  def add_language(val)
    get_dc.add_language(val.split(",").map{|x| x.strip}) unless val.nil?  
  end

  # Returns the list of languages of the collection as an array of strings 
  def get_languages
    get_dc.languages
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
  
  def get_parent_ids
    self.ids_for_outbound(:is_member_of_collection)
  end
   
  def get_child_ids
    self.ids_for_outbound(:has_collection_member)
  end

  def get_children(retCollectionsOnly = false, recurse = false, result = nil)
    
    result = Array.new if result.nil?
    
    self.ids_for_outbound(:has_collection_member).each do |x|
      x = ActiveFedora::Base.load_instance_from_solr(x.to_s)
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
    get_dc.get_xml_description.to_s
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
