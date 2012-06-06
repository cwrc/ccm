class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller  
# Adds Hydra behaviors into the application controller 
  include Hydra::Controller
  def layout_name
   'hydra-head'
  end

  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller  
# Adds Hydra behaviors into the application controller 
  include Hydra::Controller
  def layout_name
   'hydra-head'
  end
  
# Adds Hydra behaviors into the application controller 
  include Hydra::Controller
  
  def layout_name
   #'hydra-head'
   'application'
  end

  def max_records
    2 ** 31 -1
  end
  
  #Set the following variable to the URL of the API call that must be used to notify the Workflow Engine about new workflow stamps 
  def workflow_engine_new_stamp_notification_api_url
    "http://www.ualberta.ca/~ranaweer/shrek/dymmyapi.html"
  end

  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  protect_from_forgery
end
