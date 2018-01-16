require File.expand_path("../../lib/player", __FILE__)

describe Player do

  subject(:player) { Player.new(2, :black) }

  before do
    allow_any_instance_of(IO).to receive(:puts)
    allow(player).to receive(:gets).and_return("Jonathan")
  end

  describe '#elicit_name' do
    context 'given a user-entered name' do
      it 'returns the name' do
        expect(player.elicit_name(2)).to eq("Jonathan")
      end
    end
  end

  describe '#colour' do
    it 'returns the assigned colour' do
      expect(player.colour).to eq(:black)
    end
  end

  describe '#elicit_move' do
    context 'user enters a correct string' do
      it 'returns an array' do
        allow(player).to receive(:gets).and_return("a3 to d4")
        expect(player.elicit_move.class).to eq(Array)
      end
      it 'the array contains two things' do
        allow(player).to receive(:gets).and_return("a3 to d4")
        expect(player.elicit_move.length).to eq(2)
      end
      it 'returns the correct conversion' do
        allow(player).to receive(:gets).and_return("a3 to d4")
        expect(player.elicit_move).to eq([[5,1],[4,4]])
      end
      it 'returns the correct conversion' do
        allow(player).to receive(:gets).and_return("h2 to h3")
        expect(player.elicit_move).to eq([[6,8],[5,8]])
      end
      it 'returns the correct conversion' do
        allow(player).to receive(:gets).and_return("h8 to a1")
        expect(player.elicit_move).to eq([[0,8],[7,1]])
      end
      it 'returns the correct conversion' do
        allow(player).to receive(:gets).and_return("g1 to h3")
        expect(player.elicit_move).to eq([[7,7],[5,8]])
      end
    end

  end

end
