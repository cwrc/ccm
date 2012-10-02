# This is the base class for all CWRC models. 
class CcmBase < ActiveFedora::Base
  
  include Hydra::ModelMethods
  
  has_metadata :name => "DC", :type=> CcmDcDatastream
  
  # Constructor
  def initialize(params=nil)
    super(params)
    get_dc.created = DateTime.now.to_s
  end

  # Returns the DC datastream associated with the object
  def get_dc
    datastreams["DC"]
  end  
  
  # Saves the object. If this is a new object, then this call makes sure the saved object ID is added to the DC datastream and saves it agian.
  # Returns true if save is successful, and falise, otherwise.  
  def save
    update_dc_id = get_dc.identifier == ""
    status = super
    
    dc = get_dc
    if update_dc_id && status
      
      dc.identifier = self.pid
      dc.creator = "TODO"
      dc.created = "TODO"
      
      dc.dirty = true
      status = super      
    end
    
    return status
  end
  
  # Sets object type
  def type=(val)
    get_dc.type = val
  end
   
  # Returns object type
  def type
    get_dc.type
  end
  
  #Makes the solr query encoded in the specified url, parse the response, and returns an array of "doc" elements received as the response. 
  def self.get_solr_object_list(url)
    response = Net::HTTP.get_response(url)
    xml = Nokogiri::XML::Document.parse(response.body).root
    xml.xpath("/response/result/doc")
  end
  
  def self.get_objects_from_solr(model_type=nil, dc_type=nil, ret_score=false, max=nil)
    
    fields = ret_score ? "id,score" : "id"
    
    q = []
    q.push("dc.type%5C%20#{dc_type}") unless dc_type.nil?
    q.push("has_model%5C#{model_type}") unless model_type.nil?
    
    q_str = q.join("%20AND%20")
    q_str = "#{q_str}&rows=#{max}" unless max.nil?
     
    url = URI::join(ENV["solr_base"], "select?").to_s + "fl=#{fields}&q=#{q_str}" 
    puts url
    res = CcmBase.get_solr_object_list(URI::parse(url))
    
    
    ret = []  
    res.each do |doc_element|
      pid = doc_element.xpath("str[@name=\"id\"]").first.text
      if ret_score
        score = doc_element.xpath("float[@name=\"score\"]").first.text.to_f
        ret.push({:id=>pid, :score=>score})
      else
        ret.push({:id=>pid})
      end
    end
    ret
  end
  

end
