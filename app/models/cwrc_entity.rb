
class CwrcEntity < CcmBase
  
  protected
  def update_dc
    xml = datastreams["EntityMetadata"].get_xml_description
    dc = get_dc
    
    
    dc.dirty = true #flag that DC is changed, so needs to be saved
  end
  
  public
    
  has_metadata :name => "EntityMetadata", :type=> CcmEntityDatastream
  
  def get_xml_description
    return datastreams["EntityMetadata"].get_xml_description
  end

  def replace_xml_description(xmlString)
    return datastreams["EntityMetadata"].replace_xml_description(xmlString)
  end

  def self.delete_all
    CwrcEntity.find(:all).each do |x|
      begin
        x.delete
      rescue
      end
    end
  end
  
  # Updates the mappings of object description into the DC datastream and then saves the object.
  # We do not need to worry about the mapping of PID to the DC datastream here, it is take care of by the CcmBase class.   
  def save
    update_dc
    super    
  end
  
  
#  def self.get_latest_pids
#    CwrcEntity.find(:all)
#  end

#  def to_solr(solr_doc=Hash.new)
#    super
#    solr_doc["object_type_facet"] = "CwrcEntity"
#    return solr_doc
#  end
  

#
#  def self.list_ids(pageNumber, itemsPerPage)
#    entities = CwrcEntity.find(:all).paginate(:page => pageNumber, :per_page => params[:perpage])
#    
#    builder = Nokogiri::XML::Builder.new do |xml|
#      xml.pidList(:pageNumber=>"#{pageNumber}", :itemsPerPage=>"#{itemsPerPage}")
#      
#      if partType == nil
#        xml.namePart
#      else
#        xml.namePart(:partType=>"#{partType}")
#      end
#      
#    end
#    return builder.doc.root
#    
#  end
#
  

end

