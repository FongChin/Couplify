class IncomingEmailsController < ApplicationController
  
  def create
    printa params[:to]
  end
  
  def printa(a)
    p a
    p "============="
    p "============="
  end
end
