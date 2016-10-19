Rails.application.routes.draw do

  get 'standings' => 'standings#index', as: 'standings'

  resources :matches, only: [:index, :show]

  root 'matches#index'
end
