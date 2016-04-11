require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { FactoryGirl.create(:player) }

  # Validations
  # ===========
  describe "Validations" do
    it "has a valid factory" do
      expect( FactoryGirl.create(:player) ).to be_valid
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
end