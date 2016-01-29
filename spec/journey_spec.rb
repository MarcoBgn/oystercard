require 'journey'

describe Journey do

  subject(:journey)  { described_class.new }
  let(:station)         { double :station }
  let(:station2)        { double :station2 }
    
    it 'charges 4' do
      
      allow(station).to receive(:zone){4}
      journey.entry_station = station
      allow(station2).to receive(:zone){1}
      journey.exit_station = station2
      journey.complete = true
      expect(journey.fare).to eq 4
    
    end
  
  it 'is created with empty entry station' do
    expect(journey.entry_station).to eq nil
  end
  
end