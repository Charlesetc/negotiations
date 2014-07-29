Negotiations::Application.routes.draw do

	resources :users do 
		member do
			get 'toggle_admin'
			post 'last_seen'
			post 'accept_consent'
		end
	end
	
	resources :negotiations, only: [:new, :create]
	
	resources :scenarios, only: [:new, :create, :edit, :update]
	
	resources :sessions, only: [:new, :create, :destroy] # Reverse?
	
	root :to => 'static#home'

  get "static/home"

  get "static/search"

  get "static/reference"

  get "static/about"
	
	get "messages/create"
	
	post 'agree_channel', to: 'users#agree_channel' ## Delete
	post 'finish_agreement', to: 'users#finish_agreement'
	
	get 'negotiations/messages'
	post 'users/accept_background'
	post 'users/alert_request'
	post 'users/accept_alert_request'
	
	match 'index', to: 'users#index'
	match 'reference', to: 'static#reference'
	match 'about', to: 'static#about'
	match 'signup', to: 'users#new'
	match 'log_in', to: 'sessions#new'
	match 'log_out', to: 'sessions#destroy'
	match 'consent', to: 'users#consent'
	match 'background', to: 'users#background'
	match 'instructions', to: 'users#instructions'
	match 'waiting', to: 'users#waiting'
	match 'agreement', to: 'users#agreement'
	match 'thank_you', to: 'users#thank_you'
	
	match 'admin/:id' => 'tabs#admin'
	match 'background/:id' => 'tabs#background'
	match 'negotiation/:id' => 'tabs#negotiation'
	match 'supervisor/:id' => 'tabs#supervisor'
	
	get 'tabs/private_pub_subscribe'
	get 'tabs/private_pub_subscribe_admin'
	get 'tabs/waiting'
	get 'tabs/agree'
	
	match 'destroy/:id' => 'users#delete'
	match 'negotiations/destroy/:id' => 'negotiations#delete'
	match 'scenarios/destroy/:id' => 'scenarios#delete'
	match 'inspect/:id' => 'negotiations#inspect'
	
	 

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
	
	
  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
