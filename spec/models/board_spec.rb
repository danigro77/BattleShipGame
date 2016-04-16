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
    it { should have_many(:ships) }
  end

  # Methods
  # =======
  describe 'Instance Methods' do
    describe '.row' do
      it 'returns a single row of the board' do
        expect(board.row(0).map(&:row_index).uniq).to eq [0]
        expect(board.row(9).map(&:row_index).uniq).to eq [9]
      end
      it 'returns the fields in order of columns' do
        expect(board.row(0).map(&:column_index)).to eq (0..9).to_a
        expect(board.row(9).map(&:column_index)).to eq (0..9).to_a
      end
    end
    describe '.column' do
      it 'returns a single column of the board' do
        expect(board.column(0).map(&:column_index).uniq).to eq [0]
        expect(board.column(9).map(&:column_index).uniq).to eq [9]
      end
      it 'returns the fields in order of rows' do
        expect(board.column(0).map(&:row_index)).to eq (0..9).to_a
        expect(board.column(0).map(&:row_index)).to eq (0..9).to_a
      end
    end
  end

  # Filter
  # ======
  describe 'Filter' do
    let!(:ships) { board.ships }
    let!(:fields) { board.fields }
    let!(:num_ship_fields) { board.ships.inject(0) { |result, ship| result += ship.size } }

    describe 'before_validation total_ship_fields' do
      it 'adds the calculated value to the board' do
        expect(board.total_ship_fields).to_not be nil
        expect(board.total_ship_fields).to eq num_ship_fields
      end
    end

    describe 'after_create :create_ships' do
      it 'creates all the needed ships for the board' do
        Board::SHIPS.each_pair do |type, specs|
          expect(ships.map(&:ship_type)).to include type.to_s
          type_ships = ships.select { |s| s.ship_type == type.to_s }
          expect(type_ships.length).to eq specs[:quantity]
          expect(type_ships.first.size).to eq specs[:length]
        end
      end
    end

    describe 'after_create :set_fields' do
      it 'creates all the needed fields' do
        expect(fields.length).to eq 100
      end

      it 'fills them with the ships' do
        expect(fields.where('ship_id is not null').length).to eq num_ship_fields
        expect(fields.where('ship_id is not null').length).to eq board.total_ship_fields
        expect(fields.map(&:ship_id).compact.length).to eq board.ships.length
      end
    end
  end
end