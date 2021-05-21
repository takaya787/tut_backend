Rails.application.routes.draw do
  namespace 'api' do
    #login関連処理
    post '/login', to:"auth#login"
    get '/auto_login', to:"auth#auto_login"
    get '/auto_relationships', to:"auth#auto_relationships"
    get '/auto_feed', to:"auth#auto_feed"

    # activation関連
    get'account_activations/resend_email', to:"account_activations#resend_email"

    #resources 一覧
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:create,:update]
    resources :microposts,      only: [:create,:destroy,:show,:update]
    resources :relationships,   only: [:create,:destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
