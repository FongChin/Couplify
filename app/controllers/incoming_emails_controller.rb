class IncomingEmailsController < ApplicationController
  
  def create
    printa "action received"
    printa params["envelope"]["from"]
    printa params["to"]
    printa params["text"]
    printa params["attachments"]
    printa params["attachment1"]
    sender_id = User.get_id_from_email(params["from"])
    couple_id = Couple.get_couple_id(params["to"])
    printa sender_id
    printa couple_id
    body = params["text"]
    attachment = params["attachment1"]
    if attachment
      printa attachment
      printa attachment.tempfile.to_path.to_s
      img = Magick::ImageList.new(attachment.tempfile.to_path.to_s)
      printa img.to_blob
    end
    
    render :text => "success"
  end
  
  def printa(a)
    p a
    p "============="
    p "============="
  end
end
