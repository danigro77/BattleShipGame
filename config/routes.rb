Rails.application.routes.draw do
  scope '/api' do
    scope '/players' do
      get 'current' => 'players#current'
      get 'online/:id' => 'players#online'
      post 'new' => 'players#new'
      put 'logout/:id' => 'players#logout'
    end
    scope '/games' do
      post '/new/:player1/:player2' => 'games#new'
    end
  end
end
