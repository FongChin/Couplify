class IncomingEmailsController < ApplicationController
  
  def create
    printa "action received"

    begin
      ###### if to_email is sf@couplify.me, skip validation and trigger the new_post_event

      email = Mail::Address.new(params["to"]).address
      if email == "sf@couplify.me"
        skip_validation_and_save(params)
        return
      end

      ############
      
      sender_id = User.get_id_from_email(params["from"])
      couple_id = Couple.get_couple_id(params["to"])
      couple = Couple.find(couple_id)
      printa couple_id
      is_sender_owner = couple.is_sender_owner?(sender_id)
      raise "sender is not one of the owners" unless is_sender_owner
      
      if sender_id && couple_id
        body = params["subject"]
        attachment = params["attachment1"]
        
        post = Post.new(
          :couple_id => couple_id,
          :user_id => sender_id,
          :body => body,
          :image => attachment
        )
        if post.save
          begin
            Pusher["couple_#{couple_id}"].trigger("new_post_event", { 
              post: post.include_image_link_json
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
      return "something"
    end
  end
  
  def printa(a)
    p a
    p "============="
    p "============="
  end
  
  def skip_validation_and_save(params)
    couple_id = Couple.get_couple_id(params["to"])
    couple = Couple.find(couple_id)
    sender_id = couple.u1.id
    attachment = params["attachment1"]
  
    if sender_id && couple_id
      body = params["subject"]
      attachment = params["attachment1"]
    
      post = Post.new(
        :couple_id => couple_id,
        :user_id => sender_id,
        :body => body,
        :image => attachment
      )
      if post.save
        printa post
        begin
          Pusher["couple_#{couple_id}"].trigger("new_post_event", { 
            post: post.include_image_link_json
          })
        rescue Pusher::Error => e
          # save it in the database?
          printa Pusher::Error
        end
      else
        return post.errors.full_messages
      end
    else
      return 'either sender id or couple id is nil'
    end
  end
end
