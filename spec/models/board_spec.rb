require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { FactoryGirl.create(:board) }

  # Validations
  # ===========
  describe "Validations" do
    it "has a valid factory" do
      expect( FactoryGirl.create(:board) ).to be_valid
    end
    it "is invalid without a player" do
      expect( FactoryGirl.build(:board, player: nil)).not_to be_valid
    end
    it "is invalid without a game" do
      expect( FactoryGirl.build(:board, game: nil)).not_to be_valid
    end
  end

  # Relations
  # =========
  describe 'Relations' do
    it { should belong_to(:player) }
    it { should belong_to(:game) }
    it { should have_many(:fields) }
  end

end