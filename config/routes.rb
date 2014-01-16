Couplify::Application.routes.draw do
  devise_for :users

  resources :invites, :only => [:create, :new, :update, :destroy] do
    get "waiting", :on => :member
    get "make_decision", :on => :collection
  end
  
  resources :couples, :only => [:create, :update] do
    collection do
      get ":profile_name", :to => "couples#profile", :as => :profile
    end
  end
  root :to => "invites#new"
end
