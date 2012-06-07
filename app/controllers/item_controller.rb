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
    rescue
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