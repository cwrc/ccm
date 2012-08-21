# This module defines common methods for CCM models
# Include this file inside models to get access to these methods.

module CcmModelMethods

  include Hydra::ModelMethods
  
  def get_dc
    datastreams["DC"]
  end  
  
end