# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EntityHydra::Application.initialize!

ENV["testhost"] = "http://localhost:3000"
#ENV["testhost"] = "http://apps.testing.cwrc.ca:3000"

ENV["entity_root_tag"] = "entity"


