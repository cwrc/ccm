# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EntityHydra::Application.initialize!

$FEDORA = 'http://localhost:8983/fedora'
