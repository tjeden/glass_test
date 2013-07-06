GlassTest::Application.routes.draw do

  post 'glass/notifications', to: 'glass/notifications#callback', as: 'glass_notifications_callback'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root to: "home#index"
  get 'poke', to: "home#poke"
end
