Rails.application.routes.draw do
  scope '/api' do
    scope '/players' do
      get 'current' => 'players#current'
      post 'new' => 'players#new'
    end
  end
end
