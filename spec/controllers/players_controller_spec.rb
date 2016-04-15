require 'rails_helper'

RSpec.describe PlayersController, :type => :controller do
  let(:player) { FactoryGirl.create(:player) }
  let(:player_params) { {name: player.name, password: player.password} }

  describe "GET #current" do
    let(:expected_result) { {id: player.id, name: player.name} }

    it 'loads successfully' do
      get :current, {player: player_params}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'returns a player when it exists' do
      get :current, {player: player_params }

      JSON.parse(response.body)['player'].each do |key, value|
        expect(value).to eq expected_result[key.to_sym]
      end
    end

    it 'returns null when player does not exist' do
      get :current, {player: {name: "not_there", password: "bla"} }
      expect(JSON.parse(response.body)["player"]).to eq nil
    end

    it 'returns null when the name is misspelled' do
      player_params[:name] = player.name[0..-2]
      get :current, {player: player_params }
      expect(JSON.parse(response.body)["player"]).to eq nil
    end

    it 'returns null when the password is misspelled' do
      player_params[:name] = player.password[0..-2]
      get :current, {player: player_params }
      expect(JSON.parse(response.body)["player"]).to eq nil
    end
  end

  describe "GET #online" do
    let!(:online_players) { [FactoryGirl.create(:player), FactoryGirl.create(:player)] }
    let!(:offline_player) { FactoryGirl.create(:offline_player) }
    let(:expected_result) { generate_online_result(online_players) }

    it 'loads successfully' do
      get :online, {id: player.id}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'returns all online players' do
      get :online, {id: player.id}
      result = JSON.parse(response.body)["players"]
      expect(result).to eq expected_result
    end

    it 'returns not the current player' do
      get :online, {id: player.id}
      result = JSON.parse(response.body)["players"]
      expect(result).to_not include generate_online_result([player])
    end
    it 'returns not the offline player' do
      get :online, {id: player.id}
      result = JSON.parse(response.body)["players"]
      expect(result).to_not include generate_online_result([offline_player])
    end
  end

  describe "POST #new" do
    let(:new_name) { "#{player.name}_2" }
    let(:new_player_params) { {name: new_name, password: player.password} }

    it 'loads successfully' do
      post :new, {player: new_player_params}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'returns a player when it saved' do
      post :new, {player: new_player_params }

      result = JSON.parse(response.body)['player']['name']
      expect(result).to eq new_name
    end

    it 'returns an error when username already exists' do
      post :new, {player: player_params }

      result = JSON.parse(response.body)['name'].first
      expect(result).to eq "has already been taken"
      expect(response).to have_http_status(400)
    end

    it 'returns an error when username is missing' do
      post :new, {player: {password: 'bla'} }

      result = JSON.parse(response.body)['name'].first
      expect(result).to eq "can't be blank"
      expect(response).to have_http_status(400)
    end

    it 'returns an error when password is missing' do
      post :new, {player: {name: 'bla'} }

      result = JSON.parse(response.body)['password'].first
      expect(result).to eq "can't be blank"
      expect(response).to have_http_status(400)
    end
  end

  describe "PUT #logout" do
    it 'loads successfully' do
      post :logout, {id: player.id}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

#   Helpers

  def generate_online_result(online_players)
    online_players.sort_by(&:name).inject([]) do |result, player|
      result << {
          "id" => player.id,
          "name" =>player.name
      }
    end

  end
end