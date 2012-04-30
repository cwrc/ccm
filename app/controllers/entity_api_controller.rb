class EntityApiController < ApplicationController
  
  ##API actions do not require any layout formatting
  layout false
  
  ##Since th create and update actions are called via a UI which is generayed outside of rails, we need to disable forgery protection on them
  skip_before_filter :protect_from_forgery, :only => [:create, :update]
  
  def new
    entity = CwrcEntity.new
    render :text=> entity.get_xml_description.to_s
  end

  def show
    entity = CwrcEntity.find(params[:id]);
    render :text=> entity.get_xml_description.to_s
  end
  
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
    
#    begin
#     entity = CwrcEntity.find(params[:id]);
#      xml_string = params[:xml]
#      
#      entity.replace_xml_description(xml_string)
#
#      if entity.save
#        render :text => entity.pid
#      else
#        render :text => -1
#      end
#    rescue
#      render :text => -1
#    end

  end
  
end