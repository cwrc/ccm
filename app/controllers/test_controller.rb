class TestController < ApplicationController
  
  def index
    if !(params[:itemId].nil? || params[:itemId] == "")
      @item = CwrcItem.find(params[:itemId])
    end 
    
  end
  
  def entity_manager
    @object_type = "Entity"
    @api_controller = "entity"
    @test_action = "entity_manager"
    
    @object_list = CwrcEntity.get_latest_pids()
    id = params[:id]
    if !id.nil? && id != ""
      @object = CwrcEntity.find(id);   
    end
    
    render "objct_edit_form"
  end
  
  def items
    @object_type = "Item"
    @api_controller = "item"
    @test_action = "items"
    
    @object_list = CwrcItem.get_latest_pids()
    id = params[:id]
    if !id.nil? && id != ""
      @object = CwrcItem.find(id);      
    end
    
    render "objct_edit_form"
  end
  
  def collections
    @object_type = "Collection"
    @api_controller = "collection"
    @test_action = "collections"
    
    @object_list = CwrcCollection.get_latest_pids()
    id = params[:id]
    if !id.nil? && id != ""
      @object = CwrcCollection.find(id);      
    end
    
    render "objct_edit_form"
  end
  
  def collection_content
    @collection_list = CwrcCollection.find(:all)
    @item_list = CwrcItem.find(:all)
    
    if !params[:id].nil?
      @selected_collection = CwrcCollection.find(params[:id])
    end
  end

end