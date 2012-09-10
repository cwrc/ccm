require 'ccm_api_test'

def verify_collection_list_format(json_array)
  raise "No collections found. Please create some collections and re-run this test." if json_array.count == 0
  json_array.each do |entry|
    raise "Collection id is empty" if entry["id"].nil? || entry["id"].length == 0 
    raise "Entity name is empty" if entry["name"].nil? || entry["name"].length == 0
  end
end

def verify_collection_desc_format(desc_doc, collection_name = nil, owner = nil, rights = nil, contributors = nil, languages = nil)
  root = desc_doc.root
  
  ##puts "TODO: UPDATE 'verify_collection_desc_format' method in collection_spec.rb when DC implementation is completed."
  raise "Collection description is null" if root.nil?
  
  raise "Collection name #{collection_name} not found in #{root.to_s}" unless collection_name.nil? || root.to_s.include?("<dc:title>#{collection_name}</dc:title>")
  raise "Owner name #{owner} not found in #{root.to_s}" unless owner.nil? || root.to_s.include?("<dc:creator>#{owner}</dc:creator>")
  raise "Right #{rights} not found in #{root.to_s}" unless rights.nil? || root.to_s.include?("<dc:rights>#{rights}</dc:rights>")
  
  unless contributors.nil?
    contributors.split(",").map{|x| x.strip}.each do |v|
      raise "Contributor #{v} not found in #{root.to_s}" unless root.to_s.include?("<dc:contributor>#{v}</dc:contributor>")
    end
  end
end

describe "collection" do
  it "list" do
    t = CcmApiTest.new
    
    #Retrieving list of collections WITHOUT callback
    t.get("collection/list")
    
    json = t.json_body
    n = json.count
    verify_collection_list_format(json)
    
    #Retrieving list of collections WITH callback
    callback = 'my_callback_func'
    t.get("collection/list?callback=#{callback}")
    
    json = t.json_body(callback)
    verify_collection_list_format(json)
    
    #Retrieving a max number of collections when there are more than max items
    max = 5
    raise "Please create at least 6 collections before running this test." if n <= max
    t.get("collection/list?max=#{max}")
    
    json = t.json_body
    raise "Expecting #{max} number of collections, found #{json.count}" if json.count != max 
    verify_collection_list_format(json)
    
    #Retrieving a max number of collections when there are less than max collection. In this case, we should only get the available number of collections.
    max = n + 5
    t.get("collection/list?max=#{max}")
    
    json = t.json_body
    raise "Expecting #{n} number of collections, found #{json.count}" if json.count != n 
    verify_collection_list_format(json)
  end
  
  it "retrieves collection description" do
    t = CcmApiTest.new
    
    #Retrieving list of collections WITHOUT callback
    t.get("collection/list")
    
    json = t.json_body
    raise "No collections found. Please create some collections and re-run this tets" if json.count == 0
    
    id = json[0]["id"]
    
    #retreiving the collection description
    t.get("collection/#{id}")
    
    desc = t.xml_body
    verify_collection_desc_format(desc)
  end
    
  it "retrieves collection description in jsonp" do
    t = CcmApiTest.new
    
    #Retrieving list of collections WITHOUT callback
    t.get("collection/list")
    
    json = t.json_body
    raise "No collections found. Please create some collections and re-run this tets" if json.count == 0
    
    id = json[0]["id"]
    
    #retreiving the item description
    callback = "my_callback_func"
    t.get("collection/#{id}?callback=#{callback}")
    
    desc = t.xml_body(callback)
    verify_collection_desc_format(desc)
  end
  
  it "creates new collection" do
    t = CcmApiTest.new
    
    # creating a sample xml description for a new collection    
    name = "Sample Collection #{rand(1000)}"
    owner = "Sample Owner #{rand(1000)}"
    rights = "Sample Rights #{rand(1000)}"
    contributors = "contributor 1, contributor 2, contributor 3"
    language = "English, French"
    
    #making the post call to create the new collection
    params = {:name => name, :owner=>owner, :rights=>rights, :contributors=>contributors}
    t.post("collection/save", params)
    pid = t.text_body
    
    raise "Collection creation failed" if pid.start_with?("-") #A minus sign
    
    #Retrieving the newly created collection and making sure that it has the specified name
    t.get("collection/#{pid}")
    verify_collection_desc_format(t.xml_body, name)
  end
  
  it "creates new collection and associate it to another collection" do
    t = CcmApiTest.new
    
    #Retrieving list of collections
    t.get("collection/list")
    
    json = t.json_body
    raise "No collections found. Please create some collections and re-run this tets" if json.count == 0
    
    collection_id = json[0]["id"]
    
    # creating a sample xml description for a new collection    
    name = "Sample Collection #{rand(1000)}"
    
    #making the post call to create the new collection
    params = {:name => name, :parent=>collection_id}
    t.post("collection/save", params)
    pid = t.text_body
    
    raise "Collection creation failed" if pid.start_with?("-") #A minus sign
    
    #Retrieving the newly created collection and making sure that it has the specified name
    t.get("collection/#{pid}")
    verify_collection_desc_format(t.xml_body, name)
    
    t.get("collection/get_parent_collections/?id=#{pid}")
    parents = t.json_body
    
    raise "Parent collection has been failed to set while creating the collection." if parents.count == 0
    
    raise "Expected parent collection ID #{collection_id}, found #{parents[0]}" if collection_id != parents[0]
  end
  
  it "creates new collection and associate it with multiple collections" do
    t = CcmApiTest.new
    
   #Retrieving list of collections
    t.get("collection/list")
    
    json = t.json_body
    raise "Need at least 3 collections. Please create some collections and re-run this tets" if json.count < 3
    
    collection_ids = [json[0]["id"], json[1]["id"], json[2]["id"]]
    
    # creating a sample xml description for a new collection    
    name = "Sample Title #{rand(1000)}"
    
    #making the post call to create the new collection
    params = {:name => name, :parent=>collection_ids.join(",")}
    t.post("collection/save", params)
    pid = t.text_body
    
    raise "Collection creation failed" if pid.start_with?("-") #A minus sign
    
    #Retrieving the newly created collection and making sure that it has the specified name
    t.get("collection/#{pid}")
    verify_collection_desc_format(t.xml_body, name)
    
    t.get("collection/get_parent_collections/?id=#{pid}")
    parents = t.json_body
    
    raise "Expected parent collection count = #{collection_ids.count}, actual parent collection count = #{parents.count}" if parents.count != collection_ids.count
    
    collection_ids.each do |x|
      raise "Parent collection #{x} is not associated with the item #{pid}" unless parents.include?(x)
    end
  end
  
  it "updates collection" do
    t = CcmApiTest.new
    
    #finding a collection to be updated
    t.get("collection/list")
    json = t.json_body
    raise "No collections found. Please create some collections and re-run this tets" if json.count == 0
    
    id = json[0]["id"]
    
    #retreiving the collection description
    t.get("collection/#{id}")
    
    current_desc_text = t.text_body
    
    # creating an updated xml description with a different name    
    begin
      name = "Sample Name #{rand(1000)}"
    end while current_desc_text.include?(name)
    
    #updating the collection
    params = {:name => name, :id=>id}
    t.post("collection/save", params)
    pid = t.text_body
    
    raise "Collection creation failed. Expected response = #{id}, actual response = #{pid}" unless pid == id
    
    #Retrieving the newly created collection and making sure that it has the name
    t.get("collection/#{pid}")
    verify_collection_desc_format(t.xml_body, name)
  end
    
  it "link a collection with another collection as parent-child" do
    t = CcmApiTest.new
    
    #finding a parent collection and a child collection
    t.get("collection/list")
    json = t.json_body
    raise "Please create at least two collections and re-run this tets" if json.count < 2
    parent_id = json[0]["id"]
    child_id = json[1]["id"]
    
    #adding child to the parent collection
    params = {:child => child_id, :parent=>parent_id}
    t.post("collection/link_collection", params)
    ret = t.text_body
    
    raise "Associating the collection #{child_id} with the collection #{parent_id} failed." if ret.start_with?("-") #A minus sign
    
    #verifying that the child is added to the parent collection    
    t.get("collection/get_parent_collections/?id=#{child_id}")
    parents = t.json_body
    raise "Parent collection #{parent_id} is not associated with the child collection #{child_id}." unless parents.include?(parent_id)
  end
  
  it "link a collection with another set of collections as parents-child and then removing them" do
    t = CcmApiTest.new
    
    #finding a set of parent collections and a child collection
    t.get("collection/list")
    json = t.json_body
    raise "Please create at least four collections and re-run this tets" if json.count < 4
    parent_ids = [json[0]["id"], json[1]["id"], json[2]["id"]]
    child_id = json[3]["id"]
    
    #adding child to the parent collection
    params = {:child => child_id, :parent=>parent_ids.join(",")}
    t.post("collection/link_collection", params)
    ret = t.text_body
    
    raise "Associating the collection #{child_id} with the collection #{parent_ids.join(',')} failed." if ret.start_with?("-") #A minus sign
    
    #verifying that the child is added to the parent collections    
    t.get("collection/get_parent_collections/?id=#{child_id}")
    parents = t.json_body
    parent_ids.each do |x|
      raise "Parent collection #{x} is not associated with the item #{child_id}" unless parents.include?(x)
    end
    
    
    #Let's now remove one of those parent-child associations
    #========================================================
    parent_to_be_removed = parent_ids[1]
    parent_ids.delete(parent_to_be_removed)
    params = {:child => child_id, :parent=>parent_to_be_removed}
    t.post("collection/unlink_collection", params)
    ret = t.text_body
    
    raise "Removing the item #{child_id} from the collection #{parent_to_be_removed} failed" if ret.start_with?("-") #minus sign
    
    
    #verifying that the child is no,longer associated with the removed parent, but is stil associated with the remaining set of parents  
    t.get("collection/get_parent_collections/?id=#{child_id}")
    parents = t.json_body
    
    raise "The collection #{parent_to_be_removed} has not been removed from the list of parent collections of the collection #{child_id}" if parents.include?(parent_to_be_removed)
    
    parent_ids.each do |x|
      raise "Parent collection #{x} is not associated with the collection #{child_id}" unless parents.include?(x)
    end
    

    #Let's now remove all parent collections
    #=======================================
    parents_to_be_removed = parents
    params = {:child => child_id, :parent=>parents_to_be_removed.join(',')}
    t.post("collection/unlink_collection", params)
    pid = t.text_body
    
    raise "Removing all parent collections of the collection #{child_id} failed" if ret.start_with?("-") #minus sign
    
    #making sure that the child is no longer associated with any collection
    t.get("collection/get_parent_collections/?id=#{child_id}")
    parents = t.json_body
    
    raise "Expected no parent collections for the collection #{child_id}, but found #{parents.join(",")}" if parents.count > 0    
  end
  
  it "link an item with a collection as parent-child" do
    t = CcmApiTest.new
    
    #finding a parent collection 
    t.get("collection/list")
    json = t.json_body
    raise "Please create at least one collection and re-run this tets" if json.count == 0
    parent_id = json[0]["id"]
    
    #finding a child collection
    t.get("item/list")
    json = t.json_body
    raise "Please create at least one item and re-run this tets" if json.count == 0
    child_id = json[0]["id"]
    
    #adding child to the parent collection
    params = {:child => child_id, :parent=>parent_id}
    t.post("collection/link_item", params)
    ret = t.text_body
    
    raise "Associating the item #{child_id} with the collection #{parent_id} failed." if ret.start_with?("-") #A minus sign
    
    #verifying that the child is added to the parent collection    
    t.get("item/get_parent_collections/?id=#{child_id}")
    parents = t.json_body
    raise "Parent collection #{parent_id} is not associated with the child item #{child_id}." unless parents.include?(parent_id)
  end
  
  it "link an item with a set of collections as parents-child and then removing them" do
    t = CcmApiTest.new
    
    #finding a set of parent collections
    t.get("collection/list")
    json = t.json_body
    raise "Please create at least four collections and re-run this tets" if json.count < 4
    parent_ids = [json[0]["id"], json[1]["id"], json[2]["id"]]
    child_id = json[3]["id"]
    
    #finding a child collection
    t.get("item/list")
    json = t.json_body
    raise "Please create at least one item and re-run this tets" if json.count == 0
    child_id = json[0]["id"]
    
    #adding child to the parent collection
    params = {:child => child_id, :parent=>parent_ids.join(",")}
    t.post("collection/link_item", params)
    ret = t.text_body
    
    raise "Associating the item #{child_id} with the collection #{parent_ids.join(',')} failed." if ret.start_with?("-") #A minus sign
    
    #verifying that the child is added to the parent collections    
    t.get("collection/get_parent_collections/?id=#{child_id}")
    parents = t.json_body
    parent_ids.each do |x|
      raise "Parent collection #{x} is not associated with the item #{child_id}" unless parents.include?(x)
    end
    
    
    #Let's now remove one of those parent-child associations
    #========================================================
    parent_to_be_removed = parent_ids[1]
    parent_ids.delete(parent_to_be_removed)
    params = {:child => child_id, :parent=>parent_to_be_removed}
    t.post("collection/unlink_item", params)
    ret = t.text_body
    
    raise "Removing the item #{child_id} from the collection #{parent_to_be_removed} failed" if ret.start_with?("-") #minus sign
    
    #verifying that the child is no,longer associated with the removed parent, but is stil associated with the remaining set of parents  
    t.get("item/get_parent_collections/?id=#{child_id}")
    parents = t.json_body
    
    raise "The collection #{parent_to_be_removed} has not been removed from the list of parent collections of the item #{child_id}" if parents.include?(parent_to_be_removed)
    
    parent_ids.each do |x|
      raise "Parent collection #{x} is not associated with the item #{child_id}" unless parents.include?(x)
    end
    

    #Let's now remove all parent collections
    #=======================================
    parents_to_be_removed = parents
    params = {:child => child_id, :parent=>parents_to_be_removed.join(',')}
    t.post("collection/unlink_item", params)
    ret = t.text_body
    
    raise "Removing all parent collections of the collection #{child_id} failed" if ret.start_with?("-") #minus sign
    
    #making sure that the child is no longer associated with any collection
    t.get("item/get_parent_collections/?id=#{child_id}")
    parents = t.json_body
    
    raise "Expected no parent collections for the collection #{child_id}, but found #{parents.join(",")}" if parents.count > 0    
  end
      
end