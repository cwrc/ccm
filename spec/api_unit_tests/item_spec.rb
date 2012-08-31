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
    puts "item/#{id}?callback=#{callback}"
    
    desc = t.xml_body(callback)
    verify_item_desc_format(desc)
  end
  
  
  it "creates new item" do
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

end