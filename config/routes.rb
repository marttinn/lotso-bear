LotsoBear::Application.routes.draw do
  get "client_actions/home"
  get "client_actions/show"
  # root to: 'sessions#new'
  root 'sessions#new'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :prevaluations, only: [:new, :create, :show]
  resources :generic_cars, only: [:index, :new, :create, :show ,:destroy]
  resources :generic_spares, only: [:destroy]

  match '/new_generic_car', to: 'generic_cars#new',  via: 'get'
  match '/new_pre_valuations', to: 'prevaluations#new',  via: 'get'
  match '/login',              to: 'sessions#new',        via: 'get'
  match '/admin',              to: 'branches#admin',      via: 'get'
  match '/gerente',            to: 'branches#manager',    via: 'get'
  match '/ajustador',          to: 'branches#adjuster',   via: 'get'
  match '/operador',           to: 'branches#operative',  via: 'get'
  match '/capturista',         to: 'branches#capturist',  via: 'get'
  match '/proceso',            to: 'branches#process',    via: 'get'
  match '/almacen',             to: 'branches#warehouse', via: 'get'

  #Signin Trabajadores
  match '/signin',  to: 'sessions#new',         via: 'get'
  #Salir
  match '/signout', to: 'sessions#destroy',     via: 'delete'




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
