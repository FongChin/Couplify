Couplify::Application.routes.draw do
  get "static_pages/home"

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
      get ":profile_name", :to => "couples#profile", :as => :profile
      get ":profile_name/edit", :to => "couples#edit", :as => :edit_profile
    end
  end
  
  resource :incoming_email, :only => [:create]
  resources :posts, :only => [:destroy]
  root :to => "static_pages#home"
end
