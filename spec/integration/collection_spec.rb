require 'spec_helper'


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
    
    url = URI::join(ENV["testhost"], "test/collections")
    
    visit url.to_s
    page.should have_content('Input Information for a New Collection')
    
    title = "title #{rand(1000)}"
    creator = "creator #{rand(1000)}"

    fill_in 'xml', :with => '<oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/"
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
    click_on 'Create'
    
    page.should have_content("<dc:title>#{title}</dc:title>") 
    page.should have_content("<dc:creator>#{creator}</dc:creator>")
    
    object_id_list = page.find_element(:id=>"object-id-list")
    
    puts object_id_list
      
  end

  it 'creates sub collection', :js => true do
    
    url = URI::join(ENV["testhost"], "test/collections")
    
    driver = Selenium::WebDriver.for :firefox
    driver.get(url.to_s)
    
    object_key_panel = driver.find_element(:id, "object-id-list")
    
    collection_links = object_key_panel.find_elements(:partial_link_text, "collection:")
    raise "Please create at least one collection to run this test." if collection_links.count == 0

    
    parent_collection_link = collection_links[rand(collection_links.count)]
    parent_id = parent_collection_link.text
    
    new_collection_desc = driver.find_element(:name, "xml")

    title = "title #{rand(1000)}"
    creator = "creator #{rand(1000)}"
    desc = create_sample_collection_desc(title, creator)

    new_collection_desc.send_keys(desc)
    
    driver.find_element(:name, "parent").send_keys(parent_id)
    
    new_collection_desc.submit()

      
  end


end

