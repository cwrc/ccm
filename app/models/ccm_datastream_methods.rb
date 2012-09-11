# This module defines common methods for data streams used in CCM models

module CcmDatastreamMethods
  
  
  def get_xml_description
    ## Returns the XML description of the record
    
    return self.find_by_terms(:xml_description).first
  end
  
  def set_text(xpathToElement, text)
    children = get_xml_description.xpath(xpathToElement)
    raise "Element #{xpathToElement} not found" if children.count == 0
    
    children.first.content = text
    self.dirty = true
  end
 
  def get_text(xpathToElement, retAsArray=false)
    children = get_xml_description.xpath(xpathToElement)
    if retAsArray
      return children.map{ |x| x.content}
    else
      case children.count
      when 0
        return ""
      when 1
        return children.first.content
      else
        return children.map{ |x| x.content}
      end
    end
  end

  def add_element(xpathToParent, childXmlString)
    parent = get_xml_description.xpath(xpathToParent).first
    child_desc = Nokogiri::XML::Document.parse(childXmlString).root
    parent.add_child(child_desc)
    self.dirty = true
  end
  
  def remove_element(xpathToElement, matchingText = nil)
    children = get_xml_description.xpath(xpathToElement)
    children.each do |x|
      x.parent.remove(x) if matchingText.nil? || x.content == matchingText
    end
    self.dirty = true
  end
  
  def replace_xml_description(xmlString)
    ## Updates the XML description of the record using the given xmlString
    
    parent = self.find_by_terms(:xml_description).first.parent
    self.find_by_terms(:xml_description).first.remove

    new_desc = Nokogiri::XML::Document.parse(xmlString).root
    parent.add_child(new_desc) 
    self.dirty = true
  end

end

