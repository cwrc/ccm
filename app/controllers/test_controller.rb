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
    
    @object_list = CwrcEntity.find(:all, {:rows=>CwrcEntity.count})
    id = params[:id]
    unless id.nil? || id == ""
      @object = CwrcEntity.find(id);   
    end
    
    render "objct_edit_form"
  end
  
  def items
    @object_type = "Item"
    @api_controller = "item"
    @test_action = "items"
    
    @object_list = CwrcItem.find(:all, {:rows=>CwrcItem.count})
    id = params[:id]
    unless id.nil? || id == ""
      @object = CwrcItem.find(id);      
    end
    @show_parent_collection_field = true
    @parent_ids = CwrcCollection.find(:all, {:rows=>CwrcCollection.count})
    
    render "objct_edit_form"
  end
  
  def collections
    @object_type = "Collection"
    @api_controller = "collection"
    @test_action = "collections"
    
    @object_list = CwrcCollection.find(:all, {:rows=>CwrcCollection.count}) 
    id = params[:id]
    unless id.nil? || id == ""
      @object = CwrcCollection.find(id);
    end
    
    @item_type = "collection"
    @show_parent_collection_field = true
    
    render "objct_edit_form"
  end
  
  def collection_content
    @collection_list = CwrcCollection.find(:all, {:rows=>CwrcCollection.count}) 
    @item_list = CwrcItem.find(:all, {:rows=>CwrcItem.count}) 
    
    if !params[:id].nil?
      @selected_collection = CwrcCollection.find(params[:id])
    end
  end
  
  def workflow_stamps
    id = params[:id]
    unless id.nil? || id == ""
      @object = CwrcItem.find(id);      
    end
    
    @object_list = CwrcItem.find(:all, {:rows=>CwrcItem.count})
    
    render "workflow_stamps"
  end
  
  def test
    
  end

end