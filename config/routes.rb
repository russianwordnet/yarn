Yarn::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  authenticate :user, lambda { |user| user.admin? } do
    mount PgHero::Engine, at: 'pghero'
  end

  resource :profile, controller: 'users', only: [:show]

  resources :words do
    collection do
      get :search
      get :approved
    end

    member do
      get :approve
      get :disapprove
      get :history
      get :revert
    end
  end

  resources :definitions, only: [:index, :show] do
  end

  resources :synset_words, only: [:show, :edit]

  resources :synsets, only: [:index, :show, :destroy, :edit] do
    resources :definitions, only: [:show]
    resources :words, controller: 'synset_words', only: [:show] do
      resources :samples, only: [:show]
    end

    collection do
      get :search
    end

    member do
      get  :approve
      post :set_domain
    end
  end

  resources :raw_synset_words, only: [:show]

  resources :raw_synsets, only: [:index, :show] do
    resources :words, controller: 'raw_synset_words', only: [:show] do
    end

    collection do
      get :search
    end
  end

  get 'editor' => 'editor#index', :as => :editor

  namespace :editor do
    post 'search', :as => :search
    get 'definitions', :as => :definitions
    get 'synonymes', :as => :synonymes
    get 'append_word', :as => :append_word
    get 'append_definition', :as => :append_definition
    get 'word', :as => :word
    get 'next', :as => :next

    get 'ruscorpora_examples', :as => :ruscorpora_examples
    get 'opencorpora_examples', :as => :opencorpora_examples

    get 'show_synset', :as => :show_synset
    get 'sample', :as => :sample
    post 'set_default_definition', :as => :set_default_definition
    post 'set_default_synset_word', :as => :set_default_synset_word
    post 'create_synset', :as => :create_synset
    post 'update_definition', :as => :update_definition
    post 'create_sample', :as => :create_sample
    post 'edit_marks', :as => :edit_marks
    put 'save' => :save
  end

  root to: 'high_voltage/pages#show', id: 'index'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
