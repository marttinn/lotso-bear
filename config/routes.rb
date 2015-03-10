LotsoBear::Application.routes.draw do

<<<<<<< HEAD

  get "inventories/entrance"
  get "inventories/departure"
=======
  resources :car_type
>>>>>>> 4904748c39d999b6f4664dd38aea08a1ab62af2e
  resources :model_acronyms

  resources :brands

  resources :generic_families

  resources :mold_spares

  get "admin/home"
  # root to: 'sessions#new'
  root 'sessions#new'

  resources :users
  resources :generic_families, only: [:index, :new, :create, :show, :destroy]
  resources :spares, only: [:index, :new, :create, :show, :edit ,:destroy, :update]

  resources :sessions, only: [:new, :create, :destroy]
  resources :prevaluations, only: [:new, :create, :show]
  resources :valuations, only: [:index, :new, :create, :show]
  resources :generic_cars, only: [:index, :new, :create, :show, :edit ,:destroy, :update]
  resources :generic_spares, only: [:index, :new, :create, :show, :edit ,:destroy, :update]

  resources :generic_cars do
    member do
      get :assignation
    end
  end

  resources :inventories do
    collection do
      get :entrance
      get :departure
    end
  end




  match '/new_generic_spare_from_template', to: 'generic_spares#template', via: 'get'
  match '/new_generic_car', to: 'generic_cars#new',  via: 'get'
  match '/update_generation', to: 'generic_cars#update_generation',  via: 'get'


  match '/busqueda', to: 'generic_cars#search',  via: 'get'
  match '/new_pre_valuations', to: 'prevaluations#new',   via: 'get'
  match '/login',              to: 'sessions#new',        via: 'get'
  match '/admin',              to: 'branches#admin',      via: 'get'
  match '/gerente',            to: 'branches#manager',    via: 'get'
  match '/ajustador',          to: 'branches#adjuster',   via: 'get'
  match '/operador',           to: 'branches#operative',  via: 'get'
  match '/capturista',         to: 'branches#capturist',  via: 'get'
  match '/proceso',            to: 'branches#process',    via: 'get'
  match '/almacen',            to: 'branches#warehouse',  via: 'get'

  match '/count_spares/:id', to:"generic_families#count_spares", via: 'get'

  #client actions routes
  match '/consultar',            to: 'client_actions#home', via: 'get'
  match '/c/show',               to: 'client_actions#show', via: 'get'
  match '/reports',              to: 'reports#index', via: 'get'
  match '/reports/repair',       to: 'reports#repair', via: 'get'
  match '/reports/insurance',    to: 'reports#insurance', via: 'get'
  match '/reports/cars',         to: 'reports#cars', via: 'get'

  match '/roster',              to: 'roster#index', via: 'get'
  match '/roster/employeePerformance', to: 'roster#employeePerformance', via: 'get'
  match '/roster/attendance',          to: 'roster#attendance', via: 'get'

  match '/invoices',            to: 'invoices#home', via: 'get'

  match '/nuevaTemplate',            to: 'generic_spares#newtemplate', via: 'get'


  # Route to a funciton that relates families to generic cars
  get '/relate_generic_family_to_generic_car/:id', to: 'generic_cars#relate_generic_family_to_generic_car', as: 'relate_generic_family_to_generic_car'



  #Signin Trabajadores
  match '/signin',  to: 'sessions#new',         via: 'get'
  #Salir
  match '/signout', to: 'sessions#destroy',     via: 'delete'


  get '/not_assigned_families', to: 'generic_families#not_assigned_families'
  get '/assigned_families', to: 'generic_families#assigned_families'
  match '/assign_families',         to: 'generic_families#assign', via: 'post'

  get '/generic_car_assignation', to: 'generic_car#r'


  get '/build_spares/:id', to: 'generic_families#build_spares', as: 'build_spare'

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
