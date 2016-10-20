Rails.application.routes.draw do

  get 'table' => 'table#index', as: 'table'

  resources :matches, only: [:index, :show]

  root to: redirect('/matches')
end
