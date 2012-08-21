require 'spec_helper'
 
 
describe "collection" do
  it 'creates collection', :js => true do
    
    url = URI::join(ENV["testhost"], "test/collections")
    puts "visiting " + url.to_s
    
    visit url.to_s
    page.should have_content('Input Information for a New Collection')
    
  end


end

