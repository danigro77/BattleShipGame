require 'rails_helper'

RSpec.describe Ship, type: :model do
  let(:ship) { FactoryGirl.create(:ship) }

  # Validations
  # ===========
  describe "Validations" do
    it "has a valid factory" do
      expect( FactoryGirl.create(:ship) ).to be_valid
      expect( FactoryGirl.create(:submarine) ).to be_valid
      expect( FactoryGirl.create(:aircraft_carrier) ).to be_valid
      expect( FactoryGirl.create(:battleship) ).to be_valid
      expect( FactoryGirl.create(:cruiser) ).to be_valid
      expect( FactoryGirl.create(:destroyer) ).to be_valid
      expect( FactoryGirl.create(:sunken_ship) ).to be_valid
    end
    it "is invalid without a board" do
      expect( FactoryGirl.build(:ship, board: nil)).not_to be_valid
    end
    it "is invalid without a ship_type" do
      expect( FactoryGirl.build(:ship, ship_type: nil)).not_to be_valid
    end
    it "is invalid without a size" do
      expect( FactoryGirl.build(:ship, size: nil)).not_to be_valid
    end
  end

  # Relations
  # =========
  describe 'Relations' do
    it { should belong_to(:board) }
    it { should have_many(:fields) }
  end

end