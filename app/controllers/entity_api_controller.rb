class EntityApiController < ApplicationController
  
  ##API actions do not require any layout formatting
  layout false
  
  ##Since th create and update actions are called via a UI which is generayed outside of rails, we need to disable forgery protection on them
  skip_before_filter :protect_from_forgery, :only => [:save]
  
  def show
    object = CwrcEntity.find(params[:id]);
    render :xml=> object.get_xml_description
  end
  
  def save
    begin
      xml_string = params[:xml]
      id = params[:id]
      
      object = (id.nil? || id == "") ? CwrcEntity.new : CwrcEntity.find(id)
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
  
end