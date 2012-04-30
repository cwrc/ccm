class TestController < ApplicationController
  
  def index
    if !(params[:itemId].nil? || params[:itemId] == "")
      @item = CwrcItem.find(params[:itemId])
    end 
    
  end
  
  def entity_manager
    @api_controller = "entity_api"
    @test_action = "entity_manager"
    
    @object_list = CwrcEntity.get_latest_pids()
    id = params[:id]
    if !id.nil? && id != ""
      @object = CwrcEntity.find(id);   
    end
    
    render "objct_edit_form"
  end
  
  def delete_all_entities
    
  end

  def items
    @api_controller = "items_api"
    @test_action = "items"
    
    @object_list = CwrcItem.get_latest_pids()
    id = params[:id]
    if !id.nil? && id != ""
      @object = CwrcItem.find(id);      
    end
    
    render "objct_edit_form"
  end
  

end