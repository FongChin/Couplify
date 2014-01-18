class IncomingEmailsController < ApplicationController
  
  def create
    printa "action received"
    
    begin
      sender_id = User.get_id_from_email(params["from"])
      couple_id = Couple.get_couple_id(params["to"])
      if sender_id && couple_id
        body = params["text"]
        attachment = params["attachment1"]
        if attachment
          printa attachment
          printa attachment.tempfile.to_path.to_s
          img = Magick::ImageList.new(attachment.tempfile.to_path.to_s)
          s3 = AWS::S3.new(:access_key_id => ENV['AMAZONS3_KEY_ID'], :secret_access_key => ENV['AMAZONS3_SECRET_ACCESS_KEY'])

          filename_arr = attachment.original_filename.split(".")
          filename = "#{filename_arr[0].split(' ').join('_')}_#{Time.now.to_i}.#{filename_arr[1]}"
          
          key = "couples/#{couple_id}/#{filename}"
          
          s3_img = s3.buckets["couplify-development"].objects[key].write(
            img.to_blob, {:acl => :public_read}
          )
          
          img_url = "https://s3-us-west-1.amazonaws.com/couplify-development/#{s3_img.key}"

          msg = Message.new(
            :couple_id => couple_id,
            :user_id => sender_id,
            :body => body,
            :image_url => img_url
          )
          if msg.save
            printa msg
          else
            raise msg.errors.full_messages
          end
        end
      else
        raise 'either sender id or couple id is nil'
      end
            
    rescue => e
      p "error msg"
      p e.message
      email_error = EmailError.new(:params => params, :error_msg => e.message)
      email_error.save!
    ensure
      render :text => "making sure I render something for the sake of sendgrid"
    end
  end
  
  def printa(a)
    p a
    p "============="
    p "============="
  end
end
