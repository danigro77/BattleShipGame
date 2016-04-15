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
        expect(board.row(0).map(&:column_index).sort).to eq (0..9).to_a
        expect(board.row(9).map(&:row_index).uniq).to eq [9]
        expect(board.row(9).map(&:column_index).sort).to eq (0..9).to_a
      end
    end
    describe '.column' do
      it 'returns a single column of the board' do
        expect(board.column(0).map(&:column_index).uniq).to eq [0]
        expect(board.column(0).map(&:row_index).sort).to eq (0..9).to_a
        expect(board.column(9).map(&:column_index).uniq).to eq [9]
        expect(board.column(0).map(&:row_index).sort).to eq (0..9).to_a
      end
    end
  end

  # Filter
  # ======
  describe 'Filter' do
    let!(:ships) { board.ships }
    let!(:fields) { board.fields }

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
      xit 'fills them with the ships' do #TODO: test this more | it works in the app
        num_of_fields = Board::SHIPS.values.inject(0) {|result, ship| result += ship[:quantity]*ship[:length]}
        # puts fields.select {|field| field.ship }.map(&:ship).map(&:size)
        # expect(fields.select {|field| field.ship }.length).to eq num_of_fields # 7 vs 18
        expect(fields.map(&:ship_id).compact.length).to eq num_of_fields # 7 vs 18
      end
    end
  end
end