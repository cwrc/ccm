class TestController < ApplicationController
  
  def index
    if !(params[:itemId].nil? || params[:itemId] == "")
      @item = CwrcItem.find(params[:itemId])
    end 
    
  end
  
  def entity_manager
    @entities = CwrcEntity.get_latest_pids()
    id = params[:id]
    if !id.nil? && id != ""
      @entity = CwrcEntity.find(id);      
    end
  end
  
  def delete_all_entities
    
  end

end