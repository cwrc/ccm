class ApplicationController < ActionController::Base
  
  require "uri"
  require "net/http"
  
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
  
  def notify_workflow_engine(object_id, new_stamp)
    ##Notifying the Workflow engine
    url = ENV['workflow_engine_notification_url']
    
    uri = URI.parse(url)
    params = {'id' => object_id, 'stamp' => new_stamp}
    
    x = Net::HTTP.post_form(uri, params)
    x    
  end
  
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  protect_from_forgery
end
