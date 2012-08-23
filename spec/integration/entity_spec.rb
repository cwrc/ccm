require 'spec_helper'

describe "entity" do
  it 'creates entity', :js => true do
    url = URI::join(ENV["testhost"], "test/entity_manager")
    
    driver = Selenium::WebDriver.for :firefox
    driver.get(url.to_s)
    
    title = "title #{rand(1000)}"
    creator = "creator #{rand(1000)}"
    desc = create_sample_collection_desc(title, creator)

    new_collection_desc = driver.find_element(:name, "xml")
    new_collection_desc.send_keys(desc)
    
    new_collection_desc.submit()
    
    # making sure that the collection description is corectly saved
    xml_desc_text = driver.find_element(:name, "xml").to_s
    raise "The collection description doesn't seem to be saved correctly." if xml_desc_text.include?("<dc:title>#{title}</dc:title>") and xml_desc_text.include?("<dc:creator>#{creator}</dc:creator>")
    
    #close the browser
    driver.quit  
    
  end