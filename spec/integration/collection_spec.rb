require 'ccm_test'

describe "collection" do
  it 'creates collection', :js => true do
    test = CcmTest.new
    test.goto("test/collections")
    
    test.page_should_have("Input Information for a New Collection")

    # creating a scample xml description for a new collection    
    title = "title #{rand(1000)}"
    creator = "creator #{rand(1000)}"
    desc = test.create_sample_collection_desc(title, creator)
    test.fill_form_field("xml", desc)

    #submitting the form
    test.click("create_button")
    
    # making sure that the collection description is corectly saved
    test.form_filed_should_have("xml", ["<dc:title>#{title}</dc:title>", "<dc:creator>#{creator}</dc:creator>"])
    
    #close the browser
    test.quit  
  end

  it 'creates sub collection', :js => true do
    test = CcmTest.new
    test.goto("test/collections")
    
    test.page_should_have("Input Information for a New Collection")

    # creating a scample xml description for a new collection    
    title = "title #{rand(1000)}"
    creator = "creator #{rand(1000)}"
    desc = test.create_sample_collection_desc(title, creator)
    test.fill_form_field("xml", desc)
    
    # selecting a parent collection for the new collection
    object_key_panel = test.driver.find_element(:id, "object-id-list")
    collection_links = object_key_panel.find_elements(:partial_link_text, "collection:")
    raise "Please create at least one collection to run this test." if collection_links.count == 0
    
    parent_collection_link = collection_links[rand(collection_links.count)]
    parent_id = parent_collection_link.text
    
    test.fill_form_field("parent", parent_id)

    #submitting the form
    test.click("create_button")
    
    # making sure that the collection description is corectly saved
    test.form_filed_should_have("xml", ["<dc:title>#{title}</dc:title>", "<dc:creator>#{creator}</dc:creator>"])
    test.page_element_text_should_have("current-parent-ids", parent_id)
    
    test.quit  
  end


end

