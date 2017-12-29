require File.expand_path("../../lib/player", __FILE__)

describe Player do
  subject(:player) { Player.new(2, :black) }

  before do
    allow_any_instance_of(IO).to receive(:puts)
    allow(player).to receive(:gets).and_return("Jonathan")
  end

  context '#colour' do
    it 'returns the assigned colour' do
      expect(player.colour).to eq(:black)
    end

    it 'doesn\'t return the opponent\'s colour' do
      expect(player.colour).not_to eq(:white)
    end
  end

  # context '#name' do
  #   it 'returns a user-inputted name' do
  #     allow(player).to receive(:gets).and_return("Jonathan")
  #     expect(player.name).to eq("Jonathan")
  #   end
  # end
end
