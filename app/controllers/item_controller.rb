class ItemController < ApplicationController
  
  require "uri"
  require "net/http"
  
  ##API actions do not require any layout formatting
  layout false
  
  ##API methods must be accessible via third-party generated forms
  skip_before_filter :protect_from_forgery
  
  def list
    callback = params[:callback]
    max = params[:max].nil? ? max_records : params[:max].to_i
    list = CwrcItem.find(:all, {:rows=>max})
    
    ret = list.map{ |x| {:id=>x.id, :name=>x.id.to_s}}
    if callback.nil?
      render :json=>ret.to_json
    else
      render :json=>ret.to_json, :callback => params[:callback]
    end
  end
  
  def show
    callback = params[:callback]
    begin
      object = CwrcItem.find(params[:id]);
      xml = object.get_xml_description
    rescue => e
      logger.error "ITEM/SHOW ERROR: " + e.message
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
      xml_string = params[:xml]
      id = params[:id]
      parent_ids = params[:parent].nil? ? [] : params[:parent].split(",")
      
      object = (id.nil? || id == "") ? CwrcItem.new : CwrcItem.find(id)
      object.replace_xml_description(xml_string)
      
      if object.save
        object.add_to_collection(parent_ids)
        render :text => object.pid
      else
        render :text => -1
      end
    rescue => e
      logger.error "ITEM/SAVE ERROR: " + e.message
      render :text => -1
    end    
  end

  def add_to_collection
    begin
      id = params[:id]
      parent_ids = params[:parent].nil? ? [] : params[:parent].split(",")
      object = CwrcItem.find(id)
      
      raise "Item #{id} not found" if object.nil?
      
      object.add_to_collection(parent_ids)
      render :text => object.pid
    rescue => e
      logger.error "ITEM/ADD_TO_COLLECTION ERROR: #{e.message}"
      render :text => -1
    end
  end

  def remove_from_collection
    begin
      id = params[:id]
      parent_ids = params[:parent].nil? ? [] : params[:parent].split(",")
      object = CwrcItem.find(id)
      
      raise "Item #{id} not found" if object.nil?
      
      object.remove_from_collection(parent_ids)
      render :text => object.pid
    rescue => e
      logger.error "ITEM/REMOVE_FROM_COLLECTION ERROR: #{e.message}"
      render :text => -1
    end
  end

  def get_parent_collections
    callback = params[:callback]
    begin
      id = params[:id]
      object = CwrcItem.find(id)
      
      raise "Item #{id} not found" if object.nil?
      
      ret = object.get_parent_ids
      
      if callback.nil?
        render :json=>ret.to_json
      else
        render :json=>ret.to_json, :callback => params[:callback]
      end
    rescue => e
      logger.error "ITEM/GET_PARENT_COLLECTIONS ERROR: #{e.message}"
      if callback.nil?
        render :json=>-1
      else
        render :json=>-1, :callback => params[:callback]
      end
    end
  end
  
  def delete
    begin
      object = CwrcItem.find(params[:id]);
      id = object.pid
      object.delete
      render :text=> id      
    rescue => e
      logger.error "ITEM/DELETE ERROR: #{e.message}"
      render :text=>-1        
    end
  end
  
  def add_workflow_stamp
    begin
      object = CwrcItem.find(params[:id]);
      
      stamp_string = params[:xml]

      object.add_stamp_string(stamp_string)
      
      if object.save
        
        ##Notifying the Workflow engine
        url = workflow_engine_new_stamp_notification_api_url
        
        uri = URI.parse(url)
        params = {'id' => object.pid, 'stamp' => stamp_string}
        
        x = Net::HTTP.post_form(uri, params)
        
        render :text => (x.body.to_i == 0 ? object.pid : -1)
      else
        render :text => -1
      end
    rescue => e
      logger.error "ITEM/ADD_WORKFLOW_STAMP ERROR: #{e.message}"
      render :text=>-1
    end
  end
  
  def get_workflow_stamps
    object = CwrcItem.find(params[:id]);
    stamps = object.get_stamp_array
    
    ret = Array.new
    stamps.each do |x|
      ret.push(x.to_s)
    end
    
    render :json=>ret
  end
end