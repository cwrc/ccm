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
    collection_entries = object_key_panel.find_elements(:class, "entity-id")
    raise "At least one collection is required. Found 0. Please create some collecitons and re-run the test." if collection_entries.count == 0

    parent_id = collection_entries[rand(collection_entries.count)].text
    page.fill_form_field("parent", parent_id)

    #submitting the form
    page.click("create_button")
    
    # making sure that the collection description is corectly saved
    page.form_filed_should_have("xml", content)
    page.page_element_text_should_have("current-parent-ids", parent_id)
    
    #close the browser
    page.quit      
  
  end

  it 'creates item that belongs to multiple collections', :js => true do
    page = CcmTestPage.new
    page.goto("test/items")
    
    page.page_should_have("Input Information for a New Item")

    # creating a scample xml description for a new item    
    content = "item content #{rand(1000)}"
    desc = create_sample_item_desc(content)
    page.fill_form_field("xml", desc)
    
    # selecting a parent collection for the new collection
    object_key_panel = page.get_page_element("potential-parent-list")
    collection_entries = object_key_panel.find_elements(:class, "entity-id")
    rraise "At least three collection are required. Found #{collection_entries.count}. Please create some collecitons and re-run the test." if collection_entries.count < 3

    idx = rand(collection_entries.count - 1)
    parent_id_1 = collection_entries[idx].text
    parent_id_2 = collection_entries[idx + 1].text
    page.fill_form_field("parent", "#{parent_id_1}, #{parent_id_2}")

    #submitting the form
    page.click("create_button")
    
    # making sure that the collection description is corectly saved
    page.form_filed_should_have("xml", content)
    page.page_element_text_should_have("current-parent-ids", [parent_id_1, parent_id_2])
    
    #close the browser
    page.quit      
  
  end


end

