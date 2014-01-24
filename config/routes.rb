Couplify::Application.routes.draw do
  devise_for :users

  resources :invites, :only => [:create, :new, :update, :destroy] do
    get "waiting", :on => :member
    get "make_decision", :on => :collection
  end
  
  resources :couples, :only => [:create, :update] do
    member do
      resources :posts, :only => [:index]
    end
    collection do
      put ":profile_name/update_posts", :to => "posts#update_posts"
      get ":profile_name/add_posts", :to => "posts#new", :as => :new_posts
      post ":profile_name/posts", :to => "posts#create", :as => :add_posts
      get ":profile_name", :to => "couples#profile", :as => :profile
      get ":profile_name/edit", :to => "couples#edit", :as => :edit_profile
    end
  end
  
  resource :incoming_email, :only => [:create]
  resources :posts, :only => [:destroy, :update, :edit]
  root :to => "static_pages#home"
end

# resource routing and non-resourceful routes