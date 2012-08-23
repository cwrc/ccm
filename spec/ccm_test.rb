require 'spec_helper'

class CcmTest
  def initialize
    @driver = Selenium::WebDriver.for :firefox
  end
  
  def goto(relative_path)
    url = URI::join(ENV["testhost"], relative_path)
    @driver.get(url.to_s)
  end
  
  def driver
    return @driver
  end
  
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
  
  def fill_form_field(element_name, element_value)
    element = @driver.find_element(:name, element_name)
    element.send_keys(element_value)
  end
  
  def get_form_field(element_name)
    element = @driver.find_element(:name, element_name)
    railse "Element #{element_name} not found" if element.nil?
    return element.attribute("value")    
  end
  
  def check_form_filed_partial_content(element_name, element_values)
    content = get_form_field(element_name)
    
    element_values.each do |val|
      raise "#{val} not found inside the #{element_name} element." unless content.include?(val) 
    end
  end
  
  def click(button_id)
    element = @driver.find_element(:id, button_id)
    element.submit()
  end
  
  def quit
    driver.quit
  end

end

