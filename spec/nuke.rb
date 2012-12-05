require 'ccm_api_test'

describe "nuke" do
  it "deletes all items" do
    t = CcmApiTest.new
    
    ##Let's handle localhost based tests differently as it is faster to list objects by calling the find method directly on the model. 
    if ENV["testhost"] == "http://localhost:3000"
      n = 1;
      while n > 0
        ## let's retrieve a batch of 100 and delete them at a time. 
        items = CwrcItem.find(:all, {:rows=>100})
        n = items.count
        items.each do |x|
          puts "Deleting item #{x.pid}."
          t.post("item/delete", {:id => x.pid})
          raise "Item deletion failed" if t.text_body == "-1"
        end
      end         
    else
      #Retrieving list of items
      t.get("item/list")
      json = t.json_body
    
      puts ""
      #deleting each item
      json.each do |x|
        puts "Deleting item #{x["id"]}."
        t.post("item/delete", {:id => x["id"]})
        raise "Item deletion failed" if t.text_body == "-1"
      end
    end
  end
  
  
  it "deletes all entities" do
    t = CcmApiTest.new
    
    #Retrieving list of entities
    t.get("entity/list")
    json = t.json_body
    
    puts ""
    #deleting each entity
    json.each do |x|
      puts "Deleting entity #{x["id"]}."
      
      t.post("entity/delete", {:id => x["id"]})
      raise "Entity deletion failed" if t.text_body == "-1"
    end
  end
  
  it "deletes all collections" do
    t = CcmApiTest.new
    
    #Retrieving list of collections
    t.get("collection/list")
    json = t.json_body
    
    puts ""
    #deleting each collection
    json.each do |x|
      puts "Deleting collection #{x["id"]}."
      t.post("collection/delete", {:id => x["id"]})
      raise "Collection deletion failed" if t.text_body == "-1"
    end
  end
  
end

    