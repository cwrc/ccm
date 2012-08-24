require 'ccm_test_page'

def create_sample_collection_desc(title, creator)
  '<oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
      ' + "<dc:title>#{title}</dc:title>
      <dc:creator>#{creator}</dc:creator>
      <dc:subject>subject</dc:subject>
      <dc:description>dc:description</dc:description>
      <dc:publisher>publisher</dc:publisher>
      <dc:contributor>contributor</dc:contributor>
      <dc:date>2012 Jan 20</dc:date>
      <dc:type>type</dc:type>
      <dc:format>format</dc:format>
      <dc:identifier>identifier</dc:identifier>
      <dc:source>source</dc:source>
      <dc:language>language</dc:language>
      <dc:relation>relation</dc:relation>
      <dc:coverage>coverage</dc:coverage>
      <dc:rights>rights</dc:rights>
  </oai_dc:dc>
  "
end



describe "collection" do
  it 'creates collection', :js => true do
    page = CcmTestPage.new
    page.goto("test/collections")
    
    page.page_should_have("Input Information for a New Collection")

    # creating a scample xml description for a new collection    
    title = "title #{rand(1000)}"
    creator = "creator #{rand(1000)}"
    desc = create_sample_collection_desc(title, creator)
    page.fill_form_field("xml", desc)

    #submitting the form
    page.click("create_button")
    
    # making sure that the collection description is corectly saved
    page.form_filed_should_have("xml", ["<dc:title>#{title}</dc:title>", "<dc:creator>#{creator}</dc:creator>"])
    
    #close the browser
    page.quit  
  end

  it 'creates sub collection', :js => true do
    page = CcmTestPage.new
    page.goto("test/collections")
    
    page.page_should_have("Input Information for a New Collection")

    # creating a scample xml description for a new collection    
    title = "title #{rand(1000)}"
    creator = "creator #{rand(1000)}"
    desc = create_sample_collection_desc(title, creator)
    page.fill_form_field("xml", desc)
    
    # selecting a parent collection for the new collection
    collection_pids = page.get_object_ids
    raise "Please create at least one collection to run this test." if collection_pids.count == 0
    
    parent_id = collection_pids[rand(collection_pids.count)].text
    
    page.fill_form_field("parent", parent_id)

    #submitting the form
    page.click("create_button")
    
    # making sure that the collection description is corectly saved
    page.form_filed_should_have("xml", ["<dc:title>#{title}</dc:title>", "<dc:creator>#{creator}</dc:creator>"])
    page.page_element_text_should_have("current-parent-ids", parent_id)
    
    page.quit  
  end


end

