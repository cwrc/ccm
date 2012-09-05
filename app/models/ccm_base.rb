
class CcmBase < ActiveFedora::Base
  
  include Hydra::ModelMethods
  
  has_metadata :name => "DC", :type=> CcmDcDatastream

  #delegate :identifier, :to=>"DC", :unique=>true
  #delegate :title, :to=>"DC", :unique=>true

  def get_dc
    datastreams["DC"]
  end  
  
  def save
    update_dc_id = get_dc.identifier == ""
    status = super
    
    if update_dc_id && status
      get_dc.identifier = self.pid
      status = super      
    end
    
    return status
  end

end
