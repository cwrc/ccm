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

end