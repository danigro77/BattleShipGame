Rails.application.routes.draw do
  scope '/api' do
    scope '/players' do
      get 'current' => 'players#current'
      get 'online/:id' => 'players#online'
      post 'new' => 'players#new'
      put 'logout/:id' => 'players#logout'
    end
  end
end
