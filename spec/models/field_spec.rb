require 'rails_helper'

RSpec.describe Field, type: :model do
  let(:field) { FactoryGirl.create(:field) }

  # Validations
  # ===========
  describe "Validations" do
    it "has a valid factory" do
      expect( FactoryGirl.create(:field) ).to be_valid
      expect( FactoryGirl.create(:ship_field) ).to be_valid
      expect( FactoryGirl.create(:uncovered_field) ).to be_valid
      expect( FactoryGirl.create(:uncovered_ship_field) ).to be_valid
    end
    it "is invalid without a board" do
      expect( FactoryGirl.build(:field, board: nil)).not_to be_valid
    end
    it "is invalid without a row_index" do
      expect( FactoryGirl.build(:field, row_index: nil)).not_to be_valid
    end
    it "is invalid without a column_index" do
      expect( FactoryGirl.build(:field, column_index: nil)).not_to be_valid
    end
  end

  # Relations
  # =========
  describe 'Relations' do
    it { should belong_to(:board) }
  end

end