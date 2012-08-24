require 'spec_helper'

class CcmTestPage
  @@driver_singleton = nil
  def initialize
    if @@driver_singleton.nil?
      @@driver_singleton = Selenium::WebDriver.for :firefox
    end
    #@driver = Selenium::WebDriver.for :firefox
    @driver = @@driver_singleton
  end
  
  def goto(relative_path)
    url = URI::join(ENV["testhost"], relative_path)
    @driver.get(url.to_s)
  end
  
  def driver
    return @driver
  end
  
  def fill_form_field(element_name, element_value)
    element = @driver.find_element(:name, element_name)
    element.clear()
    element.send_keys(element_value)
  end
  
  def get_form_field(element_name)
    element = @driver.find_element(:name, element_name)
    railse "Element #{element_name} not found" if element.nil?
    return element.attribute("value")    
  end
  
  def form_filed_should_have(element_name, element_values)
    content = get_form_field(element_name)
    
    element_values.each do |val|
      raise "#{val} not found inside the #{element_name} element." unless content.include?(val) 
    end
  end
  
  def page_should_have(values)
    values.each do |val|
      raise "#{val} not found in the page source." unless @driver.page_source.include?(val) 
    end
  end
  
  def get_page_element(element_id)
    element = @driver.find_element(:id, element_id)
    railse "Element with id=#{element_id} not found" if element.nil?
    return element    
  end
  
  def page_element_text_should_have(element_id, values)
    values.each do |val|
      raise "#{val} not found in the page element with id = #{element_id}." unless get_page_element(element_id).text.include?(val)
    end
  end
  
  def click(target)
    t1 = get_page_element("secret-timestamp").text.to_f
    
    if target.is_a?(String)
      e = @driver.find_element(:id, target)
    else
      e = target
    end
    
    e.click

    #wait for the page to finish rendering. 
    #Here we wait the hidden timestamp at the end of the page body to have a higher value than t1.
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    wait.until { get_page_element("secret-timestamp").text.to_f > t1 }
  end
  
  def quit
    #driver.quit
  end
  
  def get_object_ids
    object_key_panel = @driver.find_element(:id, "object-id-list")
    object_links = object_key_panel.find_elements(:class, "object-id")
    object_links
  end

end

