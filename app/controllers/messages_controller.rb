class MessagesController < ApplicationController
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    render :json => { :status => 200 }
  end
end
