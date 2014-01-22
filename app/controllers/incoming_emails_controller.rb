class IncomingEmailsController < ApplicationController
  
  def create
    printa "action received"
    
    begin
      sender_id = User.get_id_from_email(params["from"])
      couple_id = Couple.get_couple_id(params["to"])
      couple = Couple.find(couple_id)
      printa couple_id
      is_sender_owner = couple.is_sender_owner?(sender_id)
      raise "sender is not one of the owners" unless is_sender_owner
      
      if sender_id && couple_id 
        body = params["text"]
        attachment = params["attachment1"]
        img_url = save_attachment(attachment, couple_id)
        
        printa img_url
        
        post = Post.new(
          :couple_id => couple_id,
          :user_id => sender_id,
          :body => body,
          :image_url => img_url
        )
        if post.save
          printa post
          begin
            Pusher["couple_#{couple_id}"].trigger("new_post_event", { 
              post: post.to_json.html_safe 
            })
          rescue Pusher::Error => e
            # save it in the database?
            printa Pusher::Error
          end
        else
          raise post.errors.full_messages
        end
      else
        raise 'either sender id or couple id is nil'
      end
    rescue => e
      p "error post"
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
  
  def save_attachment(attachment, couple_id)
    if attachment
      
      printa attachment.tempfile.read
      printa attachment.tempfile.to_path.to_s
      
      
      
      img = Magick::Image.read(attachment.tempfile.to_path.to_s).first
      img.resize_to_fit!(600)
      s3 = AWS::S3.new(:access_key_id => ENV['AMAZONS3_KEY_ID'], :secret_access_key => ENV['AMAZONS3_SECRET_ACCESS_KEY'])

      filename_arr = attachment.original_filename.split(".")
      filename = "#{filename_arr[0].split(' ').join('_')}_#{Time.now.to_i}.#{filename_arr[1]}"
    
      key = "couples/#{couple_id}/#{filename}"
    
      s3_img = s3.buckets["couplify-development"].objects[key].write(
        img.to_blob, {:acl => :public_read}
      )
    
      return "https://s3-us-west-1.amazonaws.com/couplify-development/#{s3_img.key}"
    end
    nil
  end
end
