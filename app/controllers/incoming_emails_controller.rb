class IncomingEmailsController < ApplicationController
  
  def create
    printa params["envelope"]
    printa params["to"]
    printa params["text"]
    printa params["attachments"]
    printa params["attachment-info"]
    # sender_id = User.get_id_from_email(params["envelope"]["from"])
    #     couple_id = Couple.get_couple_id(params["to"])
    #     printa sender_id
    #     printa couple_id
    #     body = params["text"]
    #     if params["attachments"] > 0
    #       params["attachment-info"].each do |attachment| do
    #         printa attachment
    #       end
    #     end
  end
  
  def printa(a)
    p a
    p "============="
    p "============="
  end
end
