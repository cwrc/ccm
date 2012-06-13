class EntityController < ApplicationController
  
  ##API actions do not require any layout formatting
  layout false
  
  ##API methods must be accessible via third-party generated forms
  skip_before_filter :protect_from_forgery, :only => [:save, :delete]
  
  def list
    callback = params[:callback]
    max = params[:max].nil? ? max_records : params[:max].to_i
    list = CwrcEntity.find(:all, {:rows=>max})
    
    ret = list.map{ |x| {:id=>x.id, :name=>x.id.to_s}}
    if callback.nil?
      render :json=>ret.to_json
    else
      render :json=>ret.to_json, :callback => callback
    end
  end
   
  def show
    callback = params[:callback]
    object = CwrcEntity.find(params[:id]);
    xml = object.get_xml_description
    
    if callback.nil?
      respond_to do |format|
        
        format.xml do
          render :xml=> xml
        end
        
        format.json do
          render :json=>CobraVsMongoose.xml_to_json(xml.to_s)

          ##Example:
          ##doc   = Nokogiri::XML(File.read('some_file.xml'))
          ##xslt  = Nokogir::XSLT(File.read('some_transformer.xslt'))
          ##puts xslt.transform(doc)
          
          ##xslt_file = "/home/kamal/projects/cwrc/cwrc_platform/lib/xslt/cwrc_entity_json_person.xsl"
          ##xslt = Nokogiri::XSLT(File.open(xslt_file, 'rb'))
          ##doc = Nokogiri::XML::Document.parse(xml.to_s)
          
          ##render :json=>xslt.transform(doc)
        end
      end
      
    else
      render :text=> callback + "(\"" + xml.to_s.gsub("\"", "\\\"").gsub("\r\n", " ").gsub("\n", " ") + "\")"      
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
  end
  
  def delete
    begin
      object = CwrcEntity.find(params[:id]);
      id = object.pid
      object.delete
      render :text=> id      
    rescue
      render :text=>-1        
    end
  end
  
  
end