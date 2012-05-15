class ItemController < ApplicationController
  
  ##API actions do not require any layout formatting
  layout false
  
  ##API methods must be accessible via third-party generated forms
  skip_before_filter :protect_from_forgery, :only => [:save, :delete]
  
  def list
    max = params[:max].nil? ? CwrcItem.count : params[:max].to_i
    list = CwrcItem.find(:all, {:rows=>max})
           
    ret = Array.new
    list.each do |x|
      ret.push(x.id)
    end
    render :text=>"Count: #{ret.count}<br /><br />#{ret.join('<br/>')}"
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

end