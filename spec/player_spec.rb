require File.expand_path("../../lib/player", __FILE__)

describe Player do

  subject(:player) { Player.new(2, :black) }

  before do
    allow_any_instance_of(IO).to receive(:puts)
  end

  describe '#name' do
    context 'given a user-entered name' do
      it 'returns the name' do
        allow(player).to receive(:gets).and_return("Jonathan")
        expect(player.name).to eq("Jonathan")
      end
    end
  end

  describe '#colour' do
    it 'returns the assigned colour' do
      expect(player.colour).to eq(:black)
    end
  end

end
