class CollectionController < ApplicationController
  
  ##API actions do not require any layout formatting
  layout false
  
  ##API methods must be accessible via third-party generated forms
  skip_before_filter :protect_from_forgery, :only => [:save, :delete]
  
  def list
    max = params[:max].nil? ? max_records : params[:max].to_i
    list = CwrcCollection.find(:all, {:rows=>max})
           
    ret = list.map{ |x| {:id=>x.id, :name=>x.id.to_s}}
    render :json=>ret.to_json
  end
    
  def show
    object = CwrcCollection.find(params[:id]);
    render :xml=> object.get_xml_description
  end
  
  def save
    begin
      xml_string = params[:xml]
      id = params[:id]
      
      object = (id.nil? || id == "") ? CwrcCollection.new : CwrcCollection.find(id)
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
      object = CwrcCollection.find(params[:id]);
      id = object.pid
      object.delete
      render :text=> id      
    rescue
      render :text=>-1        
    end
  end
  
  def link_item
    begin
      parent_ids = params[:parent].split(",")
      child = CwrcItem.find(params[:child])
      child.add_to_collection(parent_ids)
      child.save
      
      render :text=> 1
    rescue
      render :text=> -1
    end
  end

  def unlink_item
    begin
      parent_ids = params[:parent].split(",")
      child = CwrcItem.find(params[:child])
      child.remove_from_collection(parent_ids)
      child.save
      
      render :text=> 1
    rescue
      render :text=> -1
    end
  end
  
  def link_collection
    begin
      parent_ids = params[:parent].split(",")
      child = CwrcCollection.find(params[:child])
      child.add_to_collection(parent_ids)
      child.save
      
      render :text=> 1
    rescue
      render :text=> -1
    end
  end
  
  def unlink_collection
    begin
      parent_ids = params[:parent].split(",")
      child = CwrcCollection.find(params[:child])
      child.remove_from_collection(parent_ids)
      child.save
      
      render :text=> 1
    rescue
      render :text=> -1
    end
  end
  
  def children
    callback = params[:callback]
    deep = params[:deep]
    type = params[:type]
    
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
      parents = child.member_of_ids
      children = child.is_a?(CwrcCollection) ? child.members_ids : []
      
      x = {"id" => id, "name" => name, "type" => type, "parents" => parents, "children" => children}
      ret.push(x)
    end
    
    if callback.nil?
      render :json=>ret.to_json
    else
      render :json=>ret.to_json, :callback => callback
    end
  end
  
end