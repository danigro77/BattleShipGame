require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { FactoryGirl.create(:player) }

  # Validations
  # ===========
  describe "Validations" do
    it "has a valid factory" do
      expect( FactoryGirl.create(:player) ).to be_valid
      expect( FactoryGirl.create(:offline_player) ).to be_valid
      expect( FactoryGirl.create(:player_with_initiated_games) ).to be_valid
      expect( FactoryGirl.create(:player_with_invited_games) ).to be_valid
      expect( FactoryGirl.create(:player_with_won_games) ).to be_valid
      expect( FactoryGirl.create(:player_with_lost_games) ).to be_valid
      expect( FactoryGirl.create(:player_with_game_mix) ).to be_valid
    end
    it "is invalid without a name" do
      expect( FactoryGirl.build(:player, name: nil)).not_to be_valid
    end
    it "is invalid without a password" do
      expect( FactoryGirl.build(:player, password: nil)).not_to be_valid
    end
    it "is invalid when the name is not unique" do
      player_name = player.name
      expect( FactoryGirl.build(:player, name: player_name)).not_to be_valid
    end
  end

  # Relations
  # =========
  describe 'Relations' do
    let(:num_of_games) { 3 }
    #Factory :player_with_game_mix creates each time an initalized, an invited, a won and a lost game
    let!(:player_with_games) { FactoryGirl.create(:player_with_game_mix, game_count: num_of_games)}

    context("has_many initialized_games") do
      it { should have_many(:initialized_games) }

      it "returns the games the player initialized" do
        expect(player_with_games.initialized_games.count).to eq num_of_games*2
      end
    end
    context("has_many invited_games") do
      it { should have_many(:invited_games) }

      it "returns the games the player was invited to" do
        expect(player_with_games.invited_games.count).to eq num_of_games*2
      end
    end
    context("has_many current_games") do
      it { should have_many(:current_games) }

      it "returns the games the player was invited to" do
        expect(player_with_games.current_games.count).to eq num_of_games*2
      end
    end
    context("has_many won_games") do
      it { should have_many(:won_games) }

      it "returns the games the player was invited to" do
        expect(player_with_games.won_games.count).to eq num_of_games
      end
    end
  end

  # Scopes
  # ======
  describe 'Scopes' do
    let!(:offline_player) { FactoryGirl.create(:offline_player) }

    it 'returns only online player other than themselfes' do
      expect(Player.all_online(player.id)).to_not include [offline_player]
      expect(Player.all_online(player.id)).to_not include [player]
      Player.all_online(player.id).each do |online_player|
        expect(online_player.logged_in).to be true
      end
    end
  end

  # Methods
  # =======
  describe 'Instance Methods' do
    let(:num_of_games) { 3 }
    #Factory :player_with_game_mix creates each time an initalized, an invited, a won and a lost game
    let!(:player_with_games) { FactoryGirl.create(:player_with_game_mix, game_count: num_of_games)}
    let!(:another_player_with_games) { FactoryGirl.create(:player_with_game_mix, game_count: num_of_games)}
    let!(:active_game) { FactoryGirl.create(:game, player1: player_with_games, player2: another_player_with_games) }
    let!(:inactive_game) { FactoryGirl.create(:game, player1: player_with_games, player2: another_player_with_games, winner: player_with_games) }
    let(:total_games_per_player) { num_of_games*4 + 2 }

    describe ".all_games" do
      it "returns all games of a certain player" do
        expect(player_with_games.all_games.length).to eq total_games_per_player
        expect(another_player_with_games.all_games.length).to eq total_games_per_player
        expect(player_with_games.all_games).to_not eq another_player_with_games.all_games
      end
    end

    describe ".active_games" do
      it "returns all games of a certain player" do
        expect(player_with_games.active_games).to include active_game
        expect(another_player_with_games.active_games).to include active_game
      end
    end
    describe ".inactive_games" do
      it "returns all games of a certain player" do
        expect(player_with_games.inactive_games).to include inactive_game
        expect(another_player_with_games.inactive_games).to include inactive_game
      end
    end
  end

end