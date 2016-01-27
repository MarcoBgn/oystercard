require 'journey'

describe Journey do
  
  subject(:journey)  { described_class.new }
  
  describe "#fare" do

      let(:station1) { Station.new("Victoria", 1) }
      let(:station2) { Station.new("Acton Town", 3) }
    
    it { is_expected.to respond_to(:fare).with(2).arguments }
    
    it "returns a fare" do
      expect(journey.fare(station1, station2)).to eq 1
    end
  
  end
  
end