require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { FactoryGirl.create(:game) }

  # Validations
  # ===========
  describe "Validations" do
    it "has a valid factory" do
      expect( FactoryGirl.create(:game) ).to be_valid
      expect( FactoryGirl.create(:game_winner_p1) ).to be_valid
      expect( FactoryGirl.create(:game_winner_p2) ).to be_valid
      expect( FactoryGirl.create(:paused_game) ).to be_valid
    end
    it "is invalid without a player1" do
      expect( FactoryGirl.build(:game, player1: nil)).not_to be_valid
    end
    it "is invalid without a player2" do
      expect( FactoryGirl.build(:game, player2: nil)).not_to be_valid
    end
    it "is assignes player1 as current_player if nil" do
      expect( FactoryGirl.build(:game, current_player: nil)).to be_valid
    end
  end

  # Relations
  # =========
  describe 'Relations' do
    it { should belong_to(:player1) }
    it { should belong_to(:player2) }
    it { should belong_to(:winner) }
    it { should belong_to(:current_player) }
    it { should have_many(:boards) }
  end

  # Scopes
  # ======
  describe 'Scopes' do
    let(:player) { FactoryGirl.create(:player) }
    let!(:pending_invitation) { FactoryGirl.create(:game, player2: player) }
    let!(:won_game) { FactoryGirl.create(:game, player2: player, winner: player) }

    it 'returns pending game invitations for a player' do
      expect(Game.pending_invitations(player.id).to_a).to include pending_invitation
      expect(Game.pending_invitations(player.id)).to_not include won_game
    end
  end

  # Methods
  # =======
  describe 'Instance Methods' do

    describe ".change_current_player" do
      let!(:player1) { game.player1 }
      let!(:player2) { game.player2 }
      let!(:current_player) { game.current_player }

      it "changes the player" do
        expect(current_player).to eq player1
        game.change_current_player
        expect(game.current_player).to_not eq player1
        expect(game.current_player).to eq player2
      end
    end

    describe ".both_players_online?" do
      let(:offline_player) { FactoryGirl.create(:offline_player) }
      let(:game1) { FactoryGirl.create(:game, player1: offline_player) }
      let(:game2) { FactoryGirl.create(:game, player2: offline_player) }

      it "returns true if both players are online" do
        expect(game.both_players_online?).to be true
      end
      it "returns false if both or one player is offline" do
        expect(game1.both_players_online?).to be false
        expect(game2.both_players_online?).to be false
      end
    end
    describe ".not_paused?" do
      let!(:paused_game) { FactoryGirl.create(:paused_game) }

      it "returns true if the game is ongoing" do
        expect(game.not_paused?).to be true
      end
      it "returns false if the game is paused" do
        expect(paused_game.not_paused?).to be false
      end
    end
  end
end