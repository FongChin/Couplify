Couplify::Application.routes.draw do
  devise_for :users

  resource :invite, :only => [:new, :create]
  root :to => "invites#new"
end
