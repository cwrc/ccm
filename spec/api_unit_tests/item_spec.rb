require 'ccm_api_test'

def create_sample_item_desc(item_title)
  '<TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:svg="http://www.w3.org/2000/svg" xmlns:xi="http://www.w3.org/2001/XInclude">
    <teiHeader>
      <fileDesc>
        <titleStmt>
          <title>' + item_title + '</title>
          <editor sameAs="www.cwrc.ca/person/someID">Editor Name</editor>
        </titleStmt>
        <publicationStmt>
          <p/>
        </publicationStmt>
        <sourceDesc sameAs="http://www.cwrc.ca">
          <p>Created by members of CWRC/CS&#xC9;C unless otherwise noted.</p>
        </sourceDesc>
      </fileDesc>
    </teiHeader>
    <text>
      <body>
        <div type="poem">
          <head type="poem">
            <title level="a">Sample Poem Title</title>
            <title type="subtitle">Sample Subtitle</title>
          </head>
          <lg>
            <l>Verse line</l>
            <l>Verse line</l>
            <l>Verse line</l>
          </lg>
          <lg>
            <l>Verse line</l>
            <l>Verse line</l>
            <l>Verse line</l>
          </lg>
        </div>
        <div type="poem">
          <head type="poem">
            <bibl>
              <title level="a">Glimpse</title>
              <title type="subtitle">Sample Poem</title>
              <author sameAs="www.cwrc.ca/person/someID">Floris Clark McLaren</author>
            </bibl>
          </head>
          <lg>
            <l>Against the blue of spruce, and the gray</l>
            <l>Of bare-boughed poplar, suddenly</l>
            <l>As though a snowdrift burst in scattering fragments,</l>
            <l>Ptarmigan rise with heavy whir of wings,</l>
            <l>Show for a moment clear among the branches,</l>
            <l>Then disappear,</l>
            <l>White lost on white again.</l>
          </lg>
          <bibl>
            <author>McLaren, Floris Clark</author>. <title level="a">Glimpse</title>. <title level="j">Canadian Poetry Magazine</title>
            <biblScope type="vol">1.1</biblScope>
            <biblScope type="issue">
              <date>(1936)</date>
            </biblScope>: <biblScope type="pp">23</biblScope>.
    </bibl>
          <note type="research note">This poem has a suggestion of the magical imagery of <persName sameAs="www.cwrc.ca/person/someID">Kenneth Leslie</persName>&#x2019;s <title level="a">By Stubborn
     Stars</title>.</note>
          <note type="link">Poem featured in <ref target="http://ceww.wordpress.com/2012/03/21/glimpse-by-floris-clark-mclaren/">
              <title level="m" sameAs="http://ceww.wordpress.com">Canada\'s Early
      Women Writers</title>
            </ref>
          </note>
        </div>
      </body>
    </text>
  </TEI>
  '
end

def verify_item_list_format(json_array)
  raise "No items found. Please create some items and re-run this test." if json_array.count == 0
  json_array.each do |entry|
    raise "Item id is empty" if entry["id"].nil? || entry["id"].length == 0 
    raise "Item name is empty" if entry["name"].nil? || entry["name"].length == 0
  end
end

def verify_item_desc_format(desc_doc, item_title = nil)
  root = desc_doc.root
  if item_title.nil?
    raise "Item description is nil" if root.nil?
  else
    title = "<title>#{item_title}</title>"
    raise "#{title} element not found." unless root.to_s.include?(title)
  end
end

def create_sample_workflow_stamp()
  "<stamp>Workflow Stamp #{rand(1000)}</stamp>"
end

describe "item" do
  it "list" do
    t = CcmApiTest.new
    
    #Retrieving list of items WITHOUT callback
    t.get("item/list")
    
    json = t.json_body
    n = json.count
    verify_item_list_format(json)
    
    #Retrieving list of items WITH callback
    callback = 'my_callback_func'
    t.get("item/list?callback=#{callback}")
    
    json = t.json_body(callback)
    verify_item_list_format(json)
    
    #Retrieving a max number of items when there are more than max items
    max = 5
    raise "Please create at least 6 items before running this test." if n <= max
    t.get("item/list?max=#{max}")
    
    json = t.json_body
    raise "Expecting #{max} number of items, found #{json.count}" if json.count != max 
    verify_item_list_format(json)
    
    #Retrieving a max number of items when there are less than max items. In this case, we should only get the available number of items.
    max = n + 5
    t.get("item/list?max=#{max}")
    
    json = t.json_body
    raise "Expecting #{n} number of items, found #{json.count}" if json.count != n 
    verify_item_list_format(json)
  end
  
  it "retrieves item description" do
    t = CcmApiTest.new
    
    #Retrieving list of items WITHOUT callback
    t.get("item/list")
    
    json = t.json_body
    raise "No items found. Please create some items and re-run this tets" if json.count == 0
    
    id = json[0]["id"]
    
    #retreiving the item description
    t.get("item/#{id}")
    
    desc = t.xml_body
    verify_item_desc_format(desc)
  end
  
  it "retrieves item description in jsonp" do
    t = CcmApiTest.new
    
    #Retrieving list of items WITHOUT callback
    t.get("item/list")
    
    json = t.json_body
    raise "No items found. Please create some items and re-run this tets" if json.count == 0
    
    id = json[0]["id"]
    
    #retreiving the item description
    callback = "my_callback_func"
    t.get("item/#{id}?callback=#{callback}")
    
    desc = t.xml_body(callback)
    verify_item_desc_format(desc)
  end
  
  
  it "creates one new item" do
    t = CcmApiTest.new
    
    # creating a sample xml description for a new item    
    title = "Sample Title #{rand(1000)}"
    desc = create_sample_item_desc(title)
    
    #making the post call to create the new item
    params = {:xml => desc}
    t.post("item/save", params)
    pid = t.text_body
    
    raise "Item creation failed" if pid.start_with?("-") #A minus sign
    
    #Retrieving the newly created item and making sure that it has the specified title
    t.get("item/#{pid}")
    verify_item_desc_format(t.xml_body, title)
  end
  
  it "creates new item and associate it to a collection" do
    t = CcmApiTest.new
    
    #Retrieving list of collections
    t.get("collection/list")
    
    json = t.json_body
    raise "No collections found. Please create some collections and re-run this tets" if json.count == 0
    
    collection_id = json[0]["id"]
    
    # creating a sample xml description for a new item    
    title = "Sample Title #{rand(1000)}"
    desc = create_sample_item_desc(title)
    
    #making the post call to create the new item
    params = {:xml => desc, :parent=>collection_id}
    t.post("item/save", params)
    pid = t.text_body
    
    raise "Item creation failed" if pid.start_with?("-") #A minus sign
    
    #Retrieving the newly created item and making sure that it has the specified title
    t.get("item/#{pid}")
    verify_item_desc_format(t.xml_body, title)
    
    t.get("item/get_parent_collections/?id=#{pid}")
    parents = t.json_body
    
    raise "Parent collection has been failed to set while creating the item." if parents.count == 0
    
    raise "Expected parent collection ID #{collection_id}, found #{parents[0]}" if collection_id != parents[0]
  end
  
  
  it "creates new item and associate it with multiple collections" do
    t = CcmApiTest.new
    
   #Retrieving list of collections
    t.get("collection/list")
    
    json = t.json_body
    raise "Need at least 3 collections. Please create some collections and re-run this tets" if json.count < 3
    
    collection_ids = [json[0]["id"], json[1]["id"], json[2]["id"]]
    
    # creating a sample xml description for a new item    
    title = "Sample Title #{rand(1000)}"
    desc = create_sample_item_desc(title)
    
    #making the post call to create the new item
    params = {:xml => desc, :parent=>collection_ids.join(",")}
    t.post("item/save", params)
    pid = t.text_body
    
    raise "Item creation failed" if pid.start_with?("-") #A minus sign
    
    #Retrieving the newly created item and making sure that it has the specified title
    t.get("item/#{pid}")
    verify_item_desc_format(t.xml_body, title)
    
    t.get("item/get_parent_collections/?id=#{pid}")
    parents = t.json_body
    
    raise "Expected parent collection count = #{collection_ids.count}, actual parent collection count = #{parents.count}" if parents.count != collection_ids.count
    
    collection_ids.each do |x|
      raise "Parent collection #{x} is not associated with the item #{pid}" unless parents.include?(x)
    end
  end
  
 
  it "updates item" do
    t = CcmApiTest.new
    
    #finding an item to be updated
    t.get("item/list")
    json = t.json_body
    raise "No items found. Please create some items and re-run this tets" if json.count == 0
    
    id = json[0]["id"]
    
    #retreiving the item description
    t.get("item/#{id}")
    
    current_desc_text = t.text_body
    
    # creating an updated xml description with a different title name    
    begin
      title = "Sample Title #{rand(1000)}"
    end while current_desc_text.include?(title)
    new_desc_text = create_sample_item_desc(title)
    
    #updating the item
    params = {:xml => new_desc_text, :id=>id}
    t.post("item/save", params)
    pid = t.text_body
    
    raise "Item creation failed. Expected response = #{id}, actual response = #{pid}" unless pid == id
    
    #Retrieving the newly created item and making sure that it has the title
    t.get("item/#{pid}")
    verify_item_desc_format(t.xml_body, title)
  end

  it "associates an item with one collection" do
    t = CcmApiTest.new
    
    #finding an item
    t.get("item/list")
    json = t.json_body
    raise "No items found. Please create some items and re-run this tets" if json.count == 0
    item_id = json[0]["id"]
    
    #finding a collection id
    t.get("collection/list")
    json = t.json_body
    raise "No collections found. Please create some collections and re-run this tets" if json.count == 0
    collection_id = json[0]["id"]
    
    #adding the item to the collection
    params = {:id => item_id, :parent=>collection_id}
    t.post("item/add_to_collection", params)
    pid = t.text_body
    
    raise "Associating the item #{item_id} with the collection #{collection_id} failed" unless pid == item_id
    
    #verifying that the item is added to the collection    
    t.get("item/get_parent_collections/?id=#{pid}")
    parents = t.json_body
    raise "Parent collection #{collection_id} is not associated with the item #{pid}" unless parents.include?(collection_id)
  end
  
  it "associates an item with multiple collections then removing some of those associations" do
    t = CcmApiTest.new
    
    #finding an item
    t.get("item/list")
    json = t.json_body
    raise "No items found. Please create some items and re-run this tets" if json.count == 0
    item_id = json[0]["id"]
    
    #finding a collection id
    t.get("collection/list")
    json = t.json_body
    raise "Needs at least 3 collections. Please create some collections and re-run this tets" if json.count < 3
    collection_ids = [json[0]["id"], json[2]["id"], json[3]["id"]]
    
    #adding the item to the collection
    params = {:id => item_id, :parent=>collection_ids.join(",")}
    t.post("item/add_to_collection", params)
    pid = t.text_body
    
    raise "Associating the item #{item_id} with the collections #{collection_ids.join(",")} failed" unless pid == item_id
    
    #verifying that the item is added to the collections  
    t.get("item/get_parent_collections/?id=#{pid}")
    parents = t.json_body
    collection_ids.each do |x|
      raise "Parent collection #{x} is not associated with the item #{pid}" unless parents.include?(x)
    end
    

    #Let's now remove some of those parent-child associations
    #========================================================
    parent_to_be_removed = collection_ids[1]
    collection_ids.delete(parent_to_be_removed)
    params = {:id => item_id, :parent=>parent_to_be_removed}
    t.post("item/remove_from_collection", params)
    pid = t.text_body
    
    raise "Removing the item #{item_id} from the collection #{parent_to_be_removed} failed" unless pid == item_id
    
    
    #verifying that the item is no,longer associated with the removed parent, but is stil associated with the remaining set of parent collections  
    t.get("item/get_parent_collections/?id=#{pid}")
    parents = t.json_body
    
    raise "The collection #{parent_to_be_removed} has not been removed from the list of parent collections of the item #{pid}" if parents.include?(parent_to_be_removed)
    
    collection_ids.each do |x|
      raise "Parent collection #{x} is not associated with the item #{pid}" unless parents.include?(x)
    end
    

    #Let's now remove all parent collections
    #=======================================
    parents_to_be_removed = parents
    params = {:id => item_id, :parent=>parents_to_be_removed.join(',')}
    t.post("item/remove_from_collection", params)
    pid = t.text_body
    
    raise "Removing all parent collections of the item #{item_id} failed" unless pid == item_id
    
    #making sure that the item is no longer associated with any collection
    t.get("item/get_parent_collections/?id=#{pid}")
    parents = t.json_body
    
    raise "Expected no parent collections for the item #{item_id}, but found #{parents.join(",")}" if parents.count > 0
  end
  
  
  it "deletes item" do
    t = CcmApiTest.new
    
    #finding an item to be updated
    t.get("item/list")
    json = t.json_body
    raise "No items found. Please create some items and re-run this tets" if json.count == 0
    
    id = json[0]["id"]
    
    #deleting the item
    params = {:id=>id}
    t.post("item/delete", params)
    pid = t.text_body
    
    #making sure that the deleted item no longer exist
    t.get("item/#{pid}")
    puts t.text_body
    raise "Item deletion failed" unless t.text_body == ""
  end
  
  it "can add and retrieve workflow stamps" do
    t = CcmApiTest.new

    #finding an item to be updated
    t.get("item/list")
    json = t.json_body
    raise "No items found. Please create some items and re-run this tets" if json.count == 0
    
    id = json[0]["id"]
    
    stamp = create_sample_workflow_stamp()
    
    #adding the workflow stamp
    params = {:id=>id, :stamp=>stamp}
    t.post("item/add_workflow_stamp", params)
    pid = t.text_body
    raise "Adding workflow stamp #{stamp} to item #{id} might have failed. Expected to see #{id} as return, but found #{pid}" unless id == pid
    
    #retrieving the workflow stamps and making sure that the last one of them is the one that we just added.
    t.get("item/get_workflow_stamps?id=#{id}")
    json = t.json_body
    
    raise "Expected to have at least one workflow stamp but found none" if json.count == 0
    
    raise "Last workflow stamp is different from the one that was just added. Expected #{stamp}, found #{json.last}." unless json.last == stamp
  end
  
  it "can add a workflow stamp while creating an item" do
    t = CcmApiTest.new
    
   # creating a sample xml description for a new item    
    title = "Sample Title #{rand(1000)}"
    desc = create_sample_item_desc(title)
    
    #creating a sample workflow stamp
    stamp = create_sample_workflow_stamp()
    
    #making the post call to create the new item along with the worflow stamp
    params = {:xml => desc, :stamp=>stamp}
    t.post("item/save", params)
    pid = t.text_body
    
    raise "Item creation failed" if pid.start_with?("-") #A minus sign
    
    #Retrieving the newly created item and making sure that it has the specified title
    t.get("item/#{pid}")
    verify_item_desc_format(t.xml_body, title)
     
    #retrieving workflow stamps and making sure that it has one workflow stamp, which is the one that we specified.
    t.get("item/get_workflow_stamps?id=#{pid}")
    json = t.json_body
    
    raise "Expected to have at one workflow stamp but found #{json.count}" unless json.count == 1
    
    raise "The workflow stamp is different from the one that was added. Expected #{stamp}, found #{json.last}." unless json.last == stamp
  end
    
  it "can add multiple workflow stamps which are retrieved in the same order they added" do
    t = CcmApiTest.new
    
   # creating a sample xml description for a new item    
    title = "Sample Title #{rand(1000)}"
    desc = create_sample_item_desc(title)

    #making the post call to create the new item
    params = {:xml => desc}
    t.post("item/save", params)
    pid = t.text_body
    
    raise "Item creation failed" if pid.start_with?("-") #A minus sign

    #creating a set of sample workflow stamps and adding them one by one to the new object
    stamps = [create_sample_workflow_stamp(), create_sample_workflow_stamp(), create_sample_workflow_stamp(), create_sample_workflow_stamp(), create_sample_workflow_stamp()]

    stamps.each do |st|
      params = {:id=>pid, :stamp=>st}
      t.post("item/add_workflow_stamp", params)
      raise "Adding workflow stamp failed. Expected to receive #{pid} as response, found #{t.text_body}." unless pid == t.text_body
    end
    
    #retrieving the list of workflow stamps and making sure that it is the same as the ones added, and are in the same order.
    t.get("item/get_workflow_stamps?id=#{pid}")
    json = t.json_body
    
    raise "Expected to have #{stamps.count} workflow stamps, found #{json.count}" unless stamps.count == json.count
    
    (1..stamps.count).each do |i|
      raise "Expected stamp #{stamps[i]}, found #{json[i]}" unless stamps[i] == json[i]       
    end
  end
  
  it "saves items with processing instructions" do
    t = CcmApiTest.new
    
    ins_1 = '<?xml version="1.0" encoding="UTF-8"?>'
    ins_2 = '<?xml-model href="http://www.cwrc.ca/schema/cwrcbasic" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>'
    ins_3 = '<?xml-stylesheet type="text/css" href="http://www.cwrc.ca/templates/css/tei.css"?>'
    ins_4 = '<?xml-stylesheet type="text/css" href="http://www.cwrc.ca/templates/css/tei.css"?>'
    
    desc = ins_1 + ins_2 + ins_3 + '
<TEI xmlns="http://www.tei-c.org/ns/1.0">
    <teiHeader>
        ' + ins_4 + '
        <fileDesc>
            <titleStmt>
                <title>Sample Document Title</title>
            </titleStmt>
            <publicationStmt>
                <p/>
            </publicationStmt>
            <sourceDesc sameAs="http://www.cwrc.ca">
                <p>Created from original research by members of CWRC/CSÉC unless otherwise
                    noted.</p>
            </sourceDesc>
        </fileDesc>
    </teiHeader>
    <text>
        <body>
            <div type="event">
                <head>
                    <title>Sample Events from Bertrand Russell to Patricia Spence letter - October 21, 1935</title>
                </head>
                
                <listEvent>
                    <event><desc><date cert="definite" when="1935-10-21">Today</date> <name type="event:agent" sameAs="http://viaf.org/viaf/36924137/">my</name> journey lasts from 9 till 9 - fortunately one of the most beautiful railway journeys in the world.</desc></event>
                    <event when="1935-10-22"><desc> <date type="event:time" calendar="gregorian"  when="1935-10-22">Tomorrow</date> I lecture at <placeName type="event:place">Bergen</placeName> to the <orgName sameAs="http://cwrc.ca/organization/6545466" cert="probable">Anglo-Norwegian Society</orgName>.</desc></event>
                    <event><desc>Next day I go back to Oslo, lecture there Fri. and Sat.</desc></event>
                    <event><desc>and then start for home via Bergen</desc></event>
                </listEvent>
            </div>
        </body>
    </text>
</TEI>
'
    
    #making the post call to create the new item
    params = {:xml => desc}
    t.post("item/save", params)
    pid = t.text_body
    
    raise "Item creation failed" if pid.start_with?("-") #A minus sign
    
    #Retrieving the newly created item and making sure that it has the specified title
    t.get("item/#{pid}")
    
    #making sure that the three processing instructions appear outside of the root element
    #=====================================================================================
    
    source_xml = Nokogiri::XML(desc);
    retrieved_xml = t.xml_body
    
    #both documents should have the same number of childrenn (i.e. one root node and the same number of root-level processing instructions)
    raise "The retrieved doc should have #{source_xml.children.count} root-level children but found #{retrieved_xml.children.count}" unless source_xml.children.count == retrieved_xml.children.count
    
    
     
    
    
    x2 = doc_xml;
    
    
  end
end