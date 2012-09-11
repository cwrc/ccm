require 'ccm_api_test'

def create_sample_person_entity_desc(firstname, lastname)
  '<entity>
    <person xmlns="">
      <identity>
        <preferredForm>
          <namePart>'+firstname+'</namePart>
          <namePart partType="surname">'+lastname+'</namePart>
        </preferredForm>
        <variantForms>
          <variant>
            <namePart/>
            <namePart partType="surname"/>
            <variantType>birthName</variantType>
            <authorizedBy>
              <projectId/>
            </authorizedBy>
          </variant>
        </variantForms>
        <sameAs/>
        <sameAs cert=""/>
      </identity>
      <description>
        <existDates>
          <dateSingle>
            <standardDate/>
            <dateType/>
            <note/>
            <note/>
          </dateSingle>
          <dateSingle cert="">
            <standardDate/>
            <dateType>birth</dateType>
            <note/>
            <note xml:lang="english"/>
          </dateSingle>
          <dateRange>
            <fromDate>
              <standardDate/>
              <dateType/>
              <note/>
            </fromDate>
            <toDate>
              <standardDate/>
              <dateType/>
              <note/>
            </toDate>
          </dateRange>
          <dateRange cert="">
            <fromDate>
              <standardDate/>
              <dateType>birth</dateType>
              <note/>
            </fromDate>
            <toDate>
              <standardDate/>
              <dateType>birth</dateType>
              <note/>
            </toDate>
          </dateRange>
        </existDates>
        <occupations>
          <occupation>
            <term/>
          </occupation>
        </occupations>
        <activities>
          <activity>
            <term/>
          </activity>
        </activities>
        <genders>
          <gender>female</gender>
        </genders>
        <researchInterests>
          <interest>
            <term/>
          </interest>
        </researchInterests>
        <descriptiveNotes>
          <note>
            <projectId/>
            <access/>
          </note>
          <note xml:lang="english">
            <projectId/>
            <access/>
          </note>
        </descriptiveNotes>
      </description>
      <recordInfo>
        <personTypes>
          <personType/>
        </personTypes>
        <originInfo>
          <projectId/>
        </originInfo>
      </recordInfo>
    </person>
  </entity>
  '
end

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
  
  it "retrieves entity description in jsonp" do
    t = CcmApiTest.new
    
    #Retrieving list of entities WITHOUT callback
    t.get("entity/list")
    
    json = t.json_body
    raise "No entities found. Please create some entities and re-run this tets" if json.count == 0
    
    entity_id = json[0]["id"]
    
    #retreiving the entity description
    callback = "my_callback_func"
    t.get("entity/#{entity_id}?callback=#{callback}")
    
    desc = t.xml_body(callback)
    verify_entity_desc_format(desc)
  end
  
  
  it "creates one new entity" do
    t = CcmApiTest.new
    
    # creating a sample xml description for a new entity    
    firstname = "firstname #{rand(1000)}"
    lastname = "lastname #{rand(1000)}"
    desc = create_sample_person_entity_desc(firstname, lastname)
    
    #making the post call to create the new entity
    params = {:xml => desc}
    t.post("entity/save", params)
    pid = t.text_body
    
    raise "Entity creation failed" if pid == "-1"
    
    #Retrieving the newly created entity and making sure that it has the first and last names
    t.get("entity/#{pid}")
    t.text_body_include?(["<namePart>#{firstname}</namePart>", "<namePart partType=\"surname\">#{lastname}</namePart>"])
  end
  
  it "updates entity" do
    t = CcmApiTest.new
    
    #finding an entity to be updated
    t.get("entity/list")
    json = t.json_body
    raise "No entities found. Please create some entities and re-run this tets" if json.count == 0
    
    entity_id = json[0]["id"]
    
    #retreiving the entity description
    t.get("entity/#{entity_id}")
    
    current_desc_text = t.text_body
    
    # creating an updated xml description with a different first name    
    begin
      firstname = "firstname #{rand(1000)}"
    end while current_desc_text.include?(firstname)
    new_desc_text = create_sample_person_entity_desc(firstname, "")
    
    #updating the entity
    params = {:xml => new_desc_text, :id=>entity_id}
    t.post("entity/save", params)
    pid = t.text_body
    
    raise "Entity creation failed. Expected response = #{entity_id}, actual response = #{pid}" unless pid == entity_id
    
    #Retrieving the newly created entity and making sure that it has the first and last names
    t.get("entity/#{pid}")
    t.text_body_include?("<namePart>#{firstname}</namePart>")
  end

  it "deletes entity" do
    t = CcmApiTest.new
    
    #finding an entity to be updated
    t.get("entity/list")
    json = t.json_body
    raise "No entities found. Please create some entities and re-run this tets" if json.count == 0
    
    entity_id = json[0]["id"]
    
    #deleting the entity
    #updating the entity
    params = {:id=>entity_id}
    t.post("entity/delete", params)
    pid = t.text_body
    
    #making sure that the deleted entity no longer exist
    t.get("entity/#{pid}")
    puts t.text_body
    raise "Entitiy deletion failed" unless t.text_body == ""
  end

end