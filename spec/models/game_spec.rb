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
  end

end