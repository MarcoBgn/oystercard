require 'journey_log'

describe JourneyLog do
  subject(:journey_log) {described_class.new}
  let(:station) {double(:station)}
  let(:journey) {double(:journey)}
  
  it 'history starts empty' do
    expect(journey_log.history).to be_empty    
  end
  
  it 'stores journey into history' do
    journey_log.record_history(journey)
    expect(journey_log.history).to include journey
  end
end