Couplify::Application.routes.draw do
  devise_for :users

  resources :invites, :only => [:create, :new, :update, :destroy] do
    get "waiting", :on => :member
    get "make_decision", :on => :collection
  end
  
  resources :couples, :only => [:create, :update, :index] do
    collection do
      get ":profile_name", :to => "couples#profile", :as => :profile
    end
  end
  
  resource :incoming_email, :only => [:create]
  root :to => "couples#index"
end
