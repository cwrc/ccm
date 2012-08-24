require 'ccm_test_page'

def create_sample_item_desc(content)
  '
  <item>
    '+content+'
  </item>
  '
end


describe "item" do
  it 'creates item', :js => true do
    page = CcmTestPage.new
    page.goto("test/items")
    
    page.page_should_have("Input Information for a New Item")

    # creating a scample xml description for a new item    
    content = "item content #{rand(1000)}"
    desc = create_sample_item_desc(content)
    page.fill_form_field("xml", desc)

    #submitting the form
    page.click("create_button")
    
    # making sure that the collection description is corectly saved
    page.form_filed_should_have("xml", content)
    
    #close the browser
    page.quit  
  end

  it 'creates item in a collection', :js => true do
    page = CcmTestPage.new
    page.goto("test/items")
    
    page.page_should_have("Input Information for a New Item")

    # creating a scample xml description for a new item    
    content = "item content #{rand(1000)}"
    desc = create_sample_item_desc(content)
    page.fill_form_field("xml", desc)
    
    # selecting a parent collection for the new collection
    object_key_panel = page.get_page_element("potential-parent-list")
    collection_links = object_key_panel.find_elements(:class, "entity-id")
    raise "Please create at least one collection to run this test." if collection_links.count == 0
    
    parent_collection_link = collection_links[rand(collection_links.count)]
    parent_id = parent_collection_link.text
    
    page.fill_form_field("parent", parent_id)

    #submitting the form
    page.click("create_button")
    
    # making sure that the collection description is corectly saved
    page.form_filed_should_have("xml", content)
    page.page_element_text_should_have("current-parent-ids", parent_id)
    page.quit  
  end


end

