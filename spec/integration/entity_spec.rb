require 'ccm_test_page'

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

describe "entity" do
  it 'creates entity', :js => true do
    
    # visit the entity manager test page
    page = CcmTestPage.new
    page.goto("test/entity_manager")
    
    #check for the right title on the page
    page.page_should_have("Input Information for a New Entity")

    # creating a scample xml description for a new entity    
    firstname = "firstname #{rand(1000)}"
    lastname = "lastname #{rand(1000)}"
    desc = create_sample_person_entity_desc(firstname, lastname)
    page.fill_form_field("xml", desc)

    #submitting the form
    page.click("create_button")
    
    # making sure that the entity description is corectly saved. test for the irst alnd last names.
    page.form_filed_should_have("xml", ["<namePart>#{firstname}</namePart>", "<namePart partType=\"surname\">#{lastname}</namePart>"])
    
    #close the browser
    page.quit  
  end
    
  it 'edits entity', :js => true do
    
    # visit the entity manager test page
    page = CcmTestPage.new
    page.goto("test/entity_manager")
    
    #check for the right title on the page
    page.page_should_have("Input Information for a New Entity")
    
    #randomly selecting a link that represnt an entity PID
    entity_pids = page.get_object_ids
    raise "Please create at least one entity to run this test." if entity_pids.count == 0
    pid_link = entity_pids[rand(entity_pids.count)]
    pid_value = pid_link.text

    #Clicking on the link to load the entity to be edited
    page.click(pid_link)
    
    #making sure that the page title is correct
    page.page_should_have("Update #{pid_value}")
    
    #generate a new first name which is different from the existing name
    entity_desc = page.get_form_field("xml")
    begin
      firstname = "firstname #{rand(1000)}"
    end while entity_desc.include?(firstname)
          
    #creating an updated description with the new first name. let's just leave the last name blank.
    desc = create_sample_person_entity_desc(firstname, "")
    
    #fill the form field and submit
    page.fill_form_field("xml", desc)
    page.click("create_button")
    
    # making sure that the entity description is corectly saved
    page.form_filed_should_have("xml", "<namePart>#{firstname}</namePart>")
    
    #close the browser
    page.quit  
  end
        
end