class EntityController < ApplicationController
  
  ##API actions do not require any layout formatting
  layout false
  
  ##API methods must be accessible via third-party generated forms
  skip_before_filter :protect_from_forgery, :only => [:save, :delete]
  
  def list
    callback = params[:callback]
    max = params[:max].nil? ? max_records : params[:max].to_i
    type = nil #params[:type]
    
    #list = CwrcEntity.find(:all, {:rows=>max}) #using hydra framework
    #ret = list.map{ |x| {:id=>x.id, :name=>x.id.to_s}}
    
    list = CwrcEntity.list(type, max) #directly using solr API
    ret = list.map{ |x| {:id=>x[:id], :name=>x[:id].to_s}}
    
    if callback.nil?
      render :json=>ret.to_json
    else
      render :json=>ret.to_json, :callback => callback
    end
  end
   
  def show
    callback = params[:callback]
    begin
      object = CwrcEntity.find(params[:id]);
      xml = object.get_xml_description
    rescue
      xml = ""
    end
    
    if callback.nil?
      respond_to do |format|
        
        format.xml { render :xml=> xml }
                
        format.json { render :json=>CobraVsMongoose.xml_to_json(xml.to_s) }
        
        format.any { render :xml=> xml, :content_type => Mime::XML }
        
      end
      
    else
      render :text=> callback + "(\"" + xml.to_s.gsub("\"", "\\\"").gsub("\r\n", " ").gsub("\n", " ") + "\")"      
    end
  end
  
  def save
    begin
      callback = params[:callback]
      
##      if request.post?
        xml_string = params[:xml]
        id = params[:id]
        
        if id.nil? || id == ""
          object = CwrcEntity.new_entity(xml_string)
        else
          object = CwrcEntity.find(id)
          object.replace_xml_description(xml_string)
        end
        
        if object.save
          render :text => callback.nil? ? object.pid : "#{callback}(\"#{object.pid}\")"
        else
          render :text => callback.nil? ? -1 : "#{callback}(\"-1\")"
        end
##      else
##        raise "Invalid request method received"
##      end          
    rescue
      render :text => callback.nil? ? -1 : "#{callback}(\"-1\")"
    end    
  end
  
  def delete
    begin
      callback = params[:callback]
      object = CwrcEntity.find(params[:id]);
      id = object.pid
      object.delete
      render :text=> callback.nil? ? id : "#{callback}(\"#{id}\")"      
    rescue
      render :text=> callback.nil? ? -1 : "#{callback}(\"-1\")"        
    end
  end
  
  
end