Rails.application.routes.draw do
  namespace 'api' do

    #login関連処理
    post '/login', to:"auth#login"
    get '/auto_login', to:"auth#auto_login"

    #resources
    resources :users
    resources :account_activations, only: [:edit]
    resources :password_resets, only:[:create,:update]
    resources :microposts,only:[:create,:destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
