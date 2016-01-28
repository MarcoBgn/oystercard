require 'journey'

describe Journey do

  subject(:journey) {described_class.new}
  let(:station) {double :station}
  let(:card) {double :card}

  it 'is created with empty entry station' do
    expect(journey.entry_station).to eq nil
  end

end