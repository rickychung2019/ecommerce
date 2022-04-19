Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/", to: "index#home"
  post "purchase", to: "index#purchase"
  post 'getWallet', to: "index#getWallet", as: :getWallet
  post 'removeWallet', to: "index#removeWallet", as: :removeWallet
  post 'back', to: "index#back" , as: :back
end
