
class CwrcItem < CcmBase
  
  ##has_relationship "member_of", :is_member_of
  
  has_metadata :name => "ccmContentMetadata", :type=> CcmContentDatastream, :control_group=>'M' 
  has_metadata :name => "workflowStamp", :type=> CcmWorkflowDatastream
  
  def get_xml_description
    return datastreams["ccmContentMetadata"].get_xml_string
  end

  def replace_xml_description(xmlString)
    datastreams["ccmContentMetadata"].replace_xml_string(xmlString)
  end
  
  def add_stamp_string(xmlstring)
    ds = datastreams["workflowStamp"]
    ds.add_stamp(xmlstring)
  end
  
  def get_stamp_array
    ds = datastreams["workflowStamp"]
    ds.get_stamps
  end

#  def to_solr(solr_doc=Hash.new)
#    super
#    solr_doc["object_type_facet"] = "CwrcContent"
#    return solr_doc
#  end
  
end
