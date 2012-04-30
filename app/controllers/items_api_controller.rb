class ItemsApiController < ApplicationController
  
  
  def show
    
  end
  
  def save
    begin
      xml_string = params[:xml]
      id = params[:id]
      
      item = (id.nil? || id == "") ? CwrcItem.new : CwrcItem.find(id)
      item.replace_xml_description(xml_string)
      
      if item.save
        render :text => item.pid
      else
        render :text => -1
      end
    rescue
      render :text => -1
    end    
  end

  def delete
    
  end

end