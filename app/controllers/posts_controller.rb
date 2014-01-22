class PostsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :current_user_owns_profile!
  
  def index
    @couple = Couple.find(params[:id])
    @posts = @couple.posts.page(params[:page]).per(20).includes(:owner).order('created_at DESC')
    render :json => @posts
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render :json => { :status => 200 }
  end
  
  def new
    @couple = Couple.find(params[:id])
  end
  
  def create
    p "==========================="
    p "==========================="
    p params
    p "==========================="
    p "==========================="
    render :text => "Success"
  end
end
