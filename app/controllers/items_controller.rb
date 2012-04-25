class ItemsController < ApplicationController
  
  def create
    begin
      entity = CwrcEntity.new
      xml_string = params[:xml]
      
      entity.replace_xml_description(xml_string)
      
      if entity.save
        render :text => entity.pid
      else
        render :text => -1
      end
    rescue
      render :text => -1
    end    
  end
  
  def show
    
  end
  
  def save
    
  end

end