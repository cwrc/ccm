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
  def post(relativ_url, params)
    url = URI::join(ENV["testhost"], relative_url)
    @res = Net::HTTP.post_form(url, params)
  end
  
  def xml_body
    Nokogiri::XML::Document.parse(@res)
  end
  
  #converts the response body into a json array and returns it.
  #if callback parameter is supplied, the response is considered to be in jsonp format. In this case, the method verifies the presense of the callback function and returns only the argument 
  #of the callback function as a json array. 
  def json_body(callback = nil)
    s = @res
    
    unless callback.nil?
      raise "Callback function \"#{callback} not found in the response body" unless s.start_with?(callback)
      
      s = s[callback.length, s.length-callback.length]
      s.strip!
      
      raise "Response body is not in valid jsonp format" unless (s.start_with?("(") && s.end_with?(")"))
      
      s = s[1, s.length-2]
      
    end
    JSON.parse(s)
  end

end