require "uri"
require "net/http"
require 'json'
require "spec_helper"

class CcmApiTest
  
  #Makes a get call to the specified URL and stores the response in a member variable
  def get(relative_url)
    url = URI::join(ENV["testhost"], relative_url)
    @res = Net::HTTP.get(url)
  end
  
  #Makes a post call to the specified URL and stores the response in a member variable
  def post(relative_url, params)
    url = URI::join(ENV["testhost"], relative_url)
    @res = Net::HTTP.post_form(url, params).body
  end
  
  def text_body(callback = nil)
    s = @res
    
    unless callback.nil?
      raise "Callback function \"#{callback} not found in the response body" unless s.start_with?(callback)
      
      s = s[callback.length, s.length-callback.length]
      s.strip!
      
      raise "Response body is not in valid jsonp format" unless (s.start_with?("(") && s.end_with?(")"))
      
      s = s[1, s.length-2]
      
      #if s begins and ends wih double quotation marks, then the actual text should be what is encapsulated in those double quotation marks.
      s = s[1, s.length-2] if s.start_with?('"') && s.end_with?('"')
    end
    s    
  end
  
  def xml_body(callback = nil)
    s = text_body(callback)
    Nokogiri::XML::Document.parse(s)
  end
  
  #converts the response body into a json array and returns it.
  #if callback parameter is supplied, the response is considered to be in jsonp format. In this case, the method verifies the presense of the callback function and returns only the argument 
  #of the callback function as a json array. 
  def json_body(callback = nil)
    s = text_body(callback)
    JSON.parse(s)
  end
  
  def text_body_include?(values)
    s = text_body
    
    values.each do |val|
      raise "#{val} not found in the body text." unless s.include?(val)
    end
  end
  
  
  #This method tests the existance of a processing instruction at the specified location.
  #E.g.
  #   To look for <?xml-model href="http://www.cwrc.ca/schema/cwrcbasic" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?> 
  #   at the root level of a document with root tah <TEI xmlns="http://www.tei-c.org/ns/1.0">, the call should be made as follows.
  #
  #         assert_processing_instruction("//", "http://www.tei-c.org/ns/1.0", "xml-model", {"href"=>"http://www.cwrc.ca/schema/cwrcbasic", "type"=>"application/xml", "schematypens"=>"http://relaxng.org/ns/structure/1.0"})
  #
  def assert_processing_instruction(absoluteXpathToParent, xmlns, expectedProcessingInstruction)
    if xpathToParent == "//"
      parents = [xml_body]
    else
      if xmlns == "" || xmlns == nil
        parents = xml_body.xpath(xpathToParent)
      else
        path = absoluteXpathToParent.sub("/", "").sub("/","") #removing any / characters at the begining (up to two)
        parents = xml_body.xpath("//x:#{path}", "x"=>xmlns)
    end

    match_found = false
    
    parents.each do |parent|
      #all processing instructions appear as immediate or inner child levels
      pi_array = parent.xpath("//processing-instruction('#{piName}')")
      pi_array.each do |pi|
        #we need to process only immediate children of the parent      
        if pi.parent == parent
          #Processing instructions are not elements. So there is no way of extracting their contents as attributes and values. 
          #As a workaround, we create some XML elements from them and then extract the content as attribute value pairs.
          
          #converting PI content into an element
          x = Nokogiri::XML("<x #{pi.content} />")
          match = true #presume all content fields matched
          contentNameValuePairs.each_pair do |key, val|
            match = false unless x[key] == val #match is set to false if at least one specified key/valye pair is missing in the PI content
          end
          
          if match
            match_found = true
            break;
          end
        end #End: pi.parent == parent
      end #End: pi_array.each do |pi|
      
      break if match_found
    end #End: parents.each do |parent|
    
    return match_found
  end #End: def assert_processing_instruction

end