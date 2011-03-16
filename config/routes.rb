Ezlemon::Application.routes.draw do
  scope "/:locale", :locale => /en|cs/ do
    match "about_project" => "application#about_project", :via => "get"
    match "latest_activity" => "application#latest_activity", :via => "get"
    match "wall_of_fame" => "application#wall_of_fame", :via => "get"
  end

  resources :videos
  resources :feed_urls
  resources :documents
  resources :comments
  resources :pupils do
    get :languages
  end
  resources :teachers do
    get :languages
  end
  resources :messages
  resources :meetings do
    resources :meetings_users
  end
  resources :forums do
    resources :forum_topics do
      resources :forum_posts
    end
  end

  match "excercises/update_preview" => "excercises#update_preview", :via => "post"
  match "excercises/select_type" => "excercises#select_type", :via => "get"

  resources :excercises
  resources :excercises_results

  resources :translator, :only => [:index]
  match "translate" => "translator#translate", :via => :post

  resources :sitemap, :only => [:index]

  devise_for :users
  resources :users, :only => [:show]
  match "ajax_timezone" => "application#ajax_timezone", :via => "get"
  root :to => "application#index"
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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
