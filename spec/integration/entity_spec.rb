require 'ccm_test'

describe "entity" do
  it 'creates entity', :js => true do
    test = CcmTest.new
    test.goto("test/entity_manager")
    
    test.page_should_have("Input Information for a New Entity")

    # creating a scample xml description for a new collection    
    firstname = "firstname #{rand(1000)}"
    lastname = "lastname #{rand(1000)}"
    desc = test.create_sample_person_entity_desc(firstname, lastname)
    test.fill_form_field("xml", desc)

    #submitting the form
    test.click("create_button")
    
    # making sure that the collection description is corectly saved
    test.form_filed_should_have("xml", ["<namePart>#{firstname}</namePart>", "<namePart partType=\"surname\">#{lastname}</namePart>"])
    
    #close the browser
    test.quit  
  end
    
end