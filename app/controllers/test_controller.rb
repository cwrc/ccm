class TestController < ApplicationController
  
  def index
    if !(params[:itemId].nil? || params[:itemId] == "")
      @item = CwrcItem.find(params[:itemId])
    end 
    
  end

end