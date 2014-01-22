class PostsController < ApplicationController
  
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
end
