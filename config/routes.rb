Yarn::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  authenticate :user, lambda { |user| user.admin? } do
    mount PgHero::Engine, at: 'pghero'
  end

  get 'users/me' => 'users#me'
  get 'profile' => 'users#profile'
  resources :users, only: %i(show)

  get 'subsumptions' => 'subsumptions#index', :as => :subsumptions

  namespace :subsumptions do
    post 'answer', :as => :answer
  end

  resource :relations_editor, controller: :relations_editor, only: %i[show destroy] do
    post :save
    get :relations
    get :next_example
  end

  resources :words do
    collection do
      get :approved
    end

    member do
      get :synsets
      get :synonyms
      get :raw_synonyms
      get :definitions
      get :raw_definitions
      get :examples
      get :raw_examples
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

  resources :examples, only: [:index, :show] do
  end

  resources :synset_words, only: [:show, :edit]

  resources :synsets, only: [:index, :show, :destroy, :edit] do
    resources :definitions, only: [:show]
    resources :words, controller: 'synset_words', only: [:show] do
      resources :samples, only: [:show]
    end

    collection do
      get :search
      post :merge
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

  resources :posts

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
  get 'instructions' => redirect('/help')
  get 'content' => redirect('/data')
end
