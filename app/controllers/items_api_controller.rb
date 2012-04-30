class ItemsApiController < ApplicationController
  
  skip_before_filter :protect_from_forgery, :only => [:save, :delete]
  
  def show
    object = CwrcItem.find(params[:id]);
    render :xml=> object.get_xml_description
  end
  
  def save
    begin
      xml_string = params[:xml]
      id = params[:id]
      
      object = (id.nil? || id == "") ? CwrcItem.new : CwrcItem.find(id)
      object.replace_xml_description(xml_string)
      
      if object.save
        render :text => object.pid
      else
        render :text => -1
      end
    rescue
      render :text => -1
    end    
  end

  def delete
    begin
      object = CwrcItem.find(params[:id]);
      id = object.pid
      object.delete
      render :text=> id      
    rescue
      render :text=>-1        
    end
  end

end