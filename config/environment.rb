# Load the rails application
require File.expand_path('../application', __FILE__)

require File.join(Rails.root.to_s, 'config/xpaths.rb')

# Initialize the rails application
EntityHydra::Application.initialize!

ENV["testhost"] = "http://localhost:3000"
#ENV["testhost"] = "http://apps.testing.cwrc.ca:3000"

ENV["entity_root_tag"] = "entity"

ENV['workflow_engine_notification_url'] = "http://www.ualberta.ca/~ranaweer/shrek/dymmyapi.html"
#ENV['workflow_engine_notification_url'] = "http://apps.testing.cwrc.ca:8080/EventAdapter"

ENV["solr_base"] = "http://127.0.0.1:11877/solr/solr_core_default/" 
