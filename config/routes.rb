# -*- encoding : utf-8 -*-
LotsoBear::Application.routes.draw do

  resources :services

  get "supplier_codes/new"
  get "supplier_codes/edit"
  get "supplier_codes/create"
  get "supplier_codes/update"
  resources :stock_cars

  root 'sessions#new'

  resources :brands
  resources :suppliers
  resources :mold_spares
  resources :model_acronyms
  resources :sessions, only: [:new, :create, :destroy]
  resources :prevaluations, only: [:new, :create, :show]
  resources :valuations, only: [:index, :new, :create, :show]
  resources :spares, only: [:index, :new, :create, :show, :edit ,:destroy, :update]
  resources :generic_spares, only: [:index, :new, :create, :show, :edit ,:destroy, :update]

# <SUPPLIES>
  get '/supplies/consumer', to: 'supplies#consumer', as: 'consumer_supplies' #getting the user
  get '/supplies/spend/:user_code', to: 'supplies#spend', as: 'spend_fail_supplies' #supplies to spend are listed
  post '/supplies/spend', to: 'supplies#spend', as: 'spend_supplies' #supplies to spend are listed
  post '/supplies/add_supply_to_spend/', to: 'supplies#add_supply_to_spend', as:'add_supply_to_spend' #adds a single supply to spend via ajax
  post '/supplies/update_spend/', to:'supplies#update_spend', as: 'udpate_spend_supplies'
  resources :supplies do
  end
# </SUPPLIES>


# <SUPPLIER>
  get '/suppliers/:supplier_id/generic_families/:generic_family_id/new_supplier_code', to: 'supplier_codes#new', as: 'new_supplier_code'
  post '/suppliers/:supplier_id/generic_families/:generic_family_id/supplier_code_creation', to: 'supplier_codes#create', as: 'supplier_generic_family_supplier_codes'
# </SUPPLIER>

# </SHELVES>
  get 'shelves/:code/store_stocks', to: 'shelves#store_stocks', as: 'get_store_stocks_shelf'

  get 'shelves/search', to: 'shelves#search', as: 'shelves_search'
  post 'shelves/store_stocks', to: 'shelves#store_stocks', as: 'store_stocks_shelf'
  post 'shelves/save_stocks', to: 'shelves#save_stocks', as: 'save_stocks_shelf'
# </SHELVES>
# <WAREHOUSES>
  resources :warehouses do
      get 'shelves/new_bulk', to: 'shelves#new_bulk', as: 'shelves_bulk_new'
      post 'shelves/create_bulk', to: 'shelves#create_bulk', as: 'shelves_bulk_create'
      resources :shelves, shallow: true do
      end
  end
# </WAREHOUSES>




# <STOCK_FAMILIES>
  post 'stock_families/print_label', to: 'stock_families#print_label', as: 'print_label_stock_family'
  post 'stock_families/search', to: 'stock_families#search', as: 'search_stock_family'
  resources :stock_families, only: [:index, :new, :show, :edit ,:destroy, :update] do
    member do
      post :print_label
      get :history
      get :choose_labels
    end
  end
# </STOCK_FAMILIES>

# <STOCK_SPARES>
  resources :stock_spares, only: [:edit,:show,:update] do
    member do
      get :history
    end
  end
# </STOCK_SPARES>

# <ORDERS>
  resources :orders do
    member do
      post :print_label
      get :history
    end
  end
# </ORDERS>

#<GENERIC_FAMILIES>
  post 'generic_families/create_variant', to: 'generic_families#create_variant', as: 'create_variant_stock_family'
  get 'generic_families/:id/variant/:generic_car_id, ', to: 'generic_families#variant', as: 'variant_generic_family'
  get '/generic_families/results/', to: 'generic_families#results', as: 'results_generic_families'

  resources :generic_families, only: [:index, :new, :create, :show, :destroy, :update] do
    collection do
      get :not_assigned
      get :assigned
      post :assign
      get :search
    end
    member do
      # get :variant
      get :count_spares
      get :prices
    end
  end
# </GENERIC_FAMILIES>

# <GENERIC_CARS>
  resources :generic_cars do
    member do
      get :edit_generation
      get :assignation
      patch :relate_generic_family
    end
    collection do
      get :update_generation
      post :search_by_model
    end
  end
# </GENERIC_CARS>

# <INVENTORIES>
    get '/select_generic_families/:id', to: 'inventories#show_generic_car_generic_families', as: 'family_selection'
    get '/inventories/:family_id/:car_id/add_family_with_spares_to_order',to: 'inventories#add_family_with_spares_to_order'
  resources :inventories do
    member do
      get :add_family_with_spares_to_order
    end
    collection do
      get :departure
      get :all
      post :search_stock
      get :search_stock
      post :add_to_inventory, to: 'stock_families#create'
      post :departure_stock_family
      resources :stock_families, only: [:create]
      resources :supplies
    end
  end
# </INVENTORIES>

# <CLIENTS>
  match '/consultar',            to: 'client_actions#home', via: 'get'
  match '/c/show',               to: 'client_actions#show', via: 'get'
  match '/get_client_car', to: 'client_actions#get_client_car', via: 'post'
  match '/admin/suppliers/',    to: 'suppliers#index',        via: 'get'

#<CLIENT>


# <USERS>
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  resources :users do
    collection do
      get :spending
    end
    member do
      get :spending_history
    end
  end
# </USERS>


#<ADMIN>
namespace :admin do
    get :prices
  end
#</ADMIN>

  match '/signin',  to: 'sessions#new',         via: 'get'
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

end
