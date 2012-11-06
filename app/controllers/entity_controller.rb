class EntityController < ApplicationController
  
  ##API actions do not require any layout formatting
  layout false
  
  ##API methods must be accessible via third-party generated forms
  skip_before_filter :protect_from_forgery, :only => [:save, :delete]
  
  def list
    callback = params[:callback]
    max = params[:max].nil? ? max_records : params[:max].to_i
    type = params[:type]
    
    #list = CwrcEntity.find(:all, {:rows=>max}) #using hydra framework
    #ret = list.map{ |x| {:id=>x.id, :name=>x.id.to_s}}
    
    list = CwrcEntity.list(type, max) #directly using solr API
    ret = list.map{ |x| {:id=>x[:id], :name=>x[:name]}}
    
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
        parent_ids = params[:parent].nil? ? [] : params[:parent].split(",")
        
        if id.nil? || id == ""
          object = CwrcEntity.new_entity(xml_string)
        else
          object = CwrcEntity.find(id)
          object.replace_xml_description(xml_string)
        end
        
        if object.save
          object.add_to_collection(parent_ids)
          
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
  
  def add_to_collection
    begin
      id = params[:id]
      parent_ids = params[:parent].nil? ? [] : params[:parent].split(",")
      object = CwrcEntity.find(id)
      
      raise "Entity #{id} not found" if object.nil?
      
      object.add_to_collection(parent_ids)
      render :text => object.pid
    rescue => e
      logger.error "ENTITY/ADD_TO_COLLECTION ERROR: #{e.message}"
      render :text => -1
    end
  end

  def remove_from_collection
    begin
      id = params[:id]
      parent_ids = params[:parent].nil? ? [] : params[:parent].split(",")
      object = CwrcEntity.find(id)
      
      raise "Entity #{id} not found" if object.nil?
      
      object.remove_from_collection(parent_ids)
      render :text => object.pid
    rescue => e
      logger.error "ENTITY/REMOVE_FROM_COLLECTION ERROR: #{e.message}"
      render :text => -1
    end
  end

  def get_parent_collections
    callback = params[:callback]
    begin
      id = params[:id]
      object = CwrcEntity.find(id)
      
      raise "Entity #{id} not found" if object.nil?
      
      ret = object.get_parent_ids
      
      if callback.nil?
        render :json=>ret.to_json
      else
        render :json=>ret.to_json, :callback => params[:callback]
      end
    rescue => e
      logger.error "ENTITY/GET_PARENT_COLLECTIONS ERROR: #{e.message}"
      if callback.nil?
        render :json=>-1
      else
        render :json=>-1, :callback => params[:callback]
      end
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