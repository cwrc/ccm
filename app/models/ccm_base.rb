
class CcmBase < ActiveFedora::Base
  
  include Hydra::ModelMethods
  
  has_metadata :name => "DC", :type=> CcmDcDatastream

  #delegate :identifier, :to=>"DC", :unique=>true
  #delegate :title, :to=>"DC", :unique=>true

  def get_dc
    datastreams["DC"]
  end  

end
