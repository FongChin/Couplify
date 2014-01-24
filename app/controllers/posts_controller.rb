class PostsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :current_user_owns_profile!, :only => [:index]
  
  def index
    @couple = Couple.find(params[:id])
    @posts = @couple.posts.page(params[:page]).per(20).includes(:owner).order('created_at DESC')
    render :json => @posts.to_json(:methods => [:image_url]).html_safe 
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render :json => { :status => 200 }
  end
  
  def new
    @couple = Couple.find_by_profile_name(params[:profile_name])
  end
  
  def create
    @couple = Couple.find_by_profile_name(params[:profile_name])
    params[:post][:user_id] = current_user.id
    @post = @couple.posts.new(params[:post])
    if @post.save
      render :json => @post
    else
      render :json => {:status => :unprocessable_entitiy}
    end
  end
  
  def update_posts
    if Post.update(params[:posts].keys, params[:posts].values)
    else
      flash[:alert] = "Error saving your posts"  
    end
    redirect_to "/couples/#{params[:profile_name]}"
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
    else
      flash[:alert] = @post.errors.full_messages
    end
    redirect_to "/couples/#{current_user.couple.profile_name}"
  end
  
  def edit
    @post = Post.find(params[:id])
  end
end
