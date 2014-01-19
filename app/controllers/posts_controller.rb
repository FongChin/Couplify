class PostsController < ApplicationController
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render :json => { :status => 200 }
  end
end
