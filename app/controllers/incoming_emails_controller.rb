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
      s3 = AWS::S3.new(:access_key_id => ENV['AMAZONS3_KEY_ID'], :secret_access_key => ENV['AMAZONS3_SECRET_ACCESS_KEY'])
      s3_img = s3.buckets["couplify-development"].objects['couplify/#{couple_id}/#{attachment.file_name}'].write(
        img.to_blob, {:acl => :public_read}
      )
      img_url = "https://s3-us-west-1.amazonaws.com/couplify-development/#{s3_img.key}"
      
      msg = Message.create(
        :couple_id => couple_id,
        :user_id => :sender_id,
        :body => body,
        :image_url => img_url
      )
      msg.save!
    end
    
    render :text => "success"
  end
  
  def printa(a)
    p a
    p "============="
    p "============="
  end
end
