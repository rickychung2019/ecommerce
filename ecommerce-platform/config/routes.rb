Rails.application.routes.draw do
  resources :earphones
  post 'addToCart', to: "earphones#addToCart", as: :addToCart
  post 'clearCart', to: "earphones#clearCart", as: :clearCart
  post 'getWallet', to: "earphones#getWallet", as: :getWallet
  post 'removeWallet', to: "earphones#removeWallet", as: :removeWallet
  post 'purchase', to: "earphones#purchase", as: :purchase
  post 'back', to: "earphones#back" , as: :back
  root "earphones#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
