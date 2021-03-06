class CollectionController < ApplicationController
  
  ##API actions do not require any layout formatting
  layout false
  
  ##API methods must be accessible via third-party generated forms
  skip_before_filter :protect_from_forgery, :only => [:save, :delete]
  
  def list
    callback = params[:callback]
    max = params[:max].nil? ? max_records : params[:max].to_i
    list = CwrcCollection.find(:all, {:rows=>max})
           
    ret = list.map{ |x| {:id=>x.id, :name=>x.name}}
    if callback.nil?
      render :json=>ret.to_json
    else
      render :json=>ret.to_json, :callback => params[:callback]
    end
    
  end
    
  def show
    callback = params[:callback]
    begin
      object = CwrcCollection.find(params[:id]);
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
      id = params[:id]
      parent_ids = params[:parent].nil? ? [] : params[:parent].split(",")
      
      object = (id.nil? || id == "") ? CwrcCollection.new : CwrcCollection.find(id)
      
      object.name = params[:name]
      object.owner = params[:owner]
      object.created = params[:created].nil? ? DateTime.now.to_s : params[:created]
      object.rights = params[:rights] unless params[:rights].nil?
      object.add_contributor(params[:contributors]) unless params[:contributors].nil?
      object.add_language(params[:languages]) unless params[:languages].nil?

      if object.save
        object.add_to_collection(parent_ids)
        render :text => object.pid
      else
        render :text => -1
      end
    rescue => e
      logger.error "COLLECTION/SAVE ERROR: " + e.message
      render :text => -1
    end    
  end
    
  def delete
    begin
      object = CwrcCollection.find(params[:id]);
      id = object.pid
      object.delete
      render :text=> id      
    rescue => e
      logger.error "COLLECTION/DELETE ERROR: " + e.message
      render :text=>-1        
    end
  end
  
  def link_item
    begin
      parent_ids = params[:parent].split(",")
      child = CwrcItem.find(params[:child])
      
      child.add_to_collection(parent_ids) ##This call saves both the child and its parents after the relationship is added
      
      render :text=> 1
    rescue => e
      logger.error "COLLECTION/LINK_ITEM ERROR: " + e.message
      render :text=> -1
    end
  end

  def unlink_item
    begin
      parent_ids = params[:parent].split(",")
      child = CwrcItem.find(params[:child])
      
      child.remove_from_collection(parent_ids) ##This call saves both the child and its parents after the relationship is removed
      
      render :text=> 1
    rescue => e
      logger.error "COLLECTION/UNLINK_ITEM ERROR: " + e.message
      render :text=> -1
    end
  end
  
  def link_collection
    begin
      parent_ids = params[:parent].split(",")
      child = CwrcCollection.find(params[:child])
      
      child.add_to_collection(parent_ids) ##This call saves both the child and its parents after the relationship is added
      
      render :text=> 1
    rescue => e
      logger.error "COLLECTION/LINK_COLLECTION ERROR: " + e.message
      render :text=> -1
    end
  end
  
  def unlink_collection
    begin
      parent_ids = params[:parent].split(",")
      child = CwrcCollection.find(params[:child])
      
      child.remove_from_collection(parent_ids) ##This call saves both the child and its parents after the relationship is removed
      
      render :text=> 1
    rescue => e
      logger.error "COLLECTION/UNLONK_COLLECTION ERROR: " + e.message
      render :text=> -1
    end
  end

  def get_parent_collections
    callback = params[:callback]
    begin
      id = params[:id]
      object = CwrcCollection.find(id)
      
      raise "Collection #{id} not found" if object.nil?
      
      ret = object.get_parent_ids
      
      if callback.nil?
        render :json=>ret.to_json
      else
        render :json=>ret.to_json, :callback => params[:callback]
      end
    rescue => e
      logger.error "COLLECTION/GET_PARENT_COLLECTIONS ERROR: " + e.message
      if callback.nil?
        render :json=>-1
      else
        render :json=>-1, :callback => params[:callback]
      end
    end
  end
  
  
  def children
    callback = params[:callback]
    deep = params[:deep]
    type = params[:type]
    
    begin
    
      collection = CwrcCollection.find(params[:id]);
      
      ret_collections_only = type == "c"
      ret_items_only = type == "i"
      recurse = deep == "1"
       
      children = collection.get_children(ret_collections_only, recurse)
          
      ret = Array.new
      children.each do |child|
        
        next if (ret_collections_only && !child.is_a?(CwrcCollection)) || (ret_items_only && child.is_a?(CwrcCollection))
        
        id = child.pid
        name = child.pid.to_s
        type = child.is_a?(CwrcCollection) ? "c" : "i"
        parents = child.get_parent_ids
        children = child.is_a?(CwrcCollection) ? child.get_child_ids : []
        
        x = {"id" => id, "name" => name, "type" => type, "parents" => parents, "children" => children}
        ret.push(x)
      end
      
      if callback.nil?
        render :json=>ret.to_json
      else
        render :json=>ret.to_json, :callback => callback
      end
    rescue => e
      logger.error "COLLECTION/CHILDREN ERROR: " + e.message
      if callback.nil?
        render :json=>-1
      else
        render :json=>-1, :callback => params[:callback]
      end      
    end
  end
end