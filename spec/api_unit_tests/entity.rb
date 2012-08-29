require 'ccm_api_test'

def verify_entity_list_format(json_array)
  raise "No entities found. Please create some entities and re-run this test." if json_array.count == 0
  json_array.each do |entry|
    raise "Entity id is empty" if entry["id"].nil? || entry["id"].length == 0 
    raise "Entity name is empty" if entry["name"].nil? || entry["name"].length == 0
  end
end

def verify_entity_desc_format(desc_doc)
  root = desc_doc.root
  
  expected_tag = ENV["entity_root_tag"]
  raise "Expected root tag is #{expected_tag}, found #{root.name}." if root.name != expected_tag
end

describe "entity" do
  it "list" do
    t = CcmApiTest.new
    
    #Retrieving list of entities WITHOUT callback
    t.get("entity/list")
    
    json = t.json_body
    n = json.count
    verify_entity_list_format(json)
    
    #Retrieving list of entities WITH callback
    callback = 'my_callback_func'
    t.get("entity/list?callback=#{callback}")
    
    json = t.json_body(callback)
    verify_entity_list_format(json)
    
    #Retrieving a max number of entities when there are more than max entities
    max = 5
    raise "Please create at least 6 entities before running this test." if n <= max
    t.get("entity/list?max=#{max}")
    
    json = t.json_body
    raise "Expecting #{max} number of entities, found #{json.count}" if json.count != max 
    verify_entity_list_format(json)
    
    #Retrieving a max number of entities when there are less than max entities. In this case, we should only get the available number of entities.
    max = n + 5
    t.get("entity/list?max=#{max}")
    
    json = t.json_body
    raise "Expecting #{n} number of entities, found #{json.count}" if json.count != n 
    verify_entity_list_format(json)
  end
  
  it "retrieves entity description" do
    t = CcmApiTest.new
    
    #Retrieving list of entities WITHOUT callback
    t.get("entity/list")
    
    json = t.json_body
    raise "No entities found. Please create some entities and re-run this tets" if json.count == 0
    
    entity_id = json[0]["id"]
    
    #retreiving the entity description
    t.get("entity/#{entity_id}")
    
    desc = t.xml_body
    verify_entity_desc_format(desc)
  end
  

end