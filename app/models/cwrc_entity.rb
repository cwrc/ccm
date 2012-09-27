
class CwrcEntity < CcmBase
  
  protected
  def update_dc
    entity_ds = datastreams["EntityMetadata"]
    dc = get_dc
    
    dc.title = entity_ds.display_name
    dc.title = "#{entity_ds.surname} #{entity_ds.forename}".strip if dc.title == ""
    dc.title = entity_ds.preferred_form_names.join(" ") if dc.title == ""

    dc.type = entity_ds.type
    
    dc.dirty = true #flag that DC is changed, so needs to be saved
  end
  
  private
  def initialize(namespace)
    super(:namespace=>namespace)
  end

  public
  has_metadata :name => "EntityMetadata", :type=> CcmEntityDatastream
  
  def self.new_entity(xmlString)
    desc = Nokogiri::XML::Document.parse(xmlString).root
    namespace = CcmEntityDatastream.get_type(desc)
    
    entity = CwrcEntity.new(namespace)
    entity.datastreams["EntityMetadata"].replace_xml_description(desc)
    entity
  end
  
  def self.new_person
    CwrcEntity.new("person")
  end
  
  def self.new_organization
    CwrcEntity.new("organization")
  end
  
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

