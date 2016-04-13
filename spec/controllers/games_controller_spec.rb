require 'rails_helper'

RSpec.describe GamesController, :type => :controller do
  let(:player1) { FactoryGirl.create(:player) }
  let(:player2) { FactoryGirl.create(:player) }

  describe "POST #new" do
    let(:expected_keys) { %w(id current_player_id player1 player2) }

    it 'loads successfully' do
      post :new, {player1: player1, player2: player2}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'returns a game when it saved' do
      post :new, {player1: player1, player2: player2}

      result = JSON.parse(response.body)['game']
      expect(result.keys).to eq expected_keys
      expect(result['current_player_id']).to eq player1.id
      expect(result['player1']).to eq clean_player(player1)
      expect(result['player2']).to eq clean_player(player2)
    end
  end

#   HELPERS
  def clean_player(player)
    {
        "id" => player.id,
        "name" => player.name
    }
  end

end