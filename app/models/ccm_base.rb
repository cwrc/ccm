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
    
    if update_dc_id && status
      get_dc.identifier = self.pid
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



end
