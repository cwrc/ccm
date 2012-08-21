
class CcmBase < ActiveFedora::Base
  
  include CcmModelMethods
  
  has_metadata :name => "DC", :type=> CcmDcDatastream

  #delegate :identifier, :to=>"DC", :unique=>true
  #delegate :title, :to=>"DC", :unique=>true

end
