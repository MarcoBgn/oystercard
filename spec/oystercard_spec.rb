require 'oystercard'

describe OysterCard do

  subject(:card) { described_class.new }
  let(:station)  { double :station }
  let(:station2) { double :station2 }
  let(:journey) { double :journey }

  before(:each) do
    
    allow(station).to receive(:name).and_return(station)
    allow(station2).to receive(:name).and_return(station2)
    allow(station).to receive(:zone) {1}
    allow(station2).to receive(:zone) {1}
    
  end


  it 'initializes with a balance of 0' do
    
    expect(card.balance).to eq 0
    
  end

  it 'stores one journey in history' do
    
    card.top_up(OysterCard::MIN_FARE)
    card.touch_in(station)
    card.touch_out(station2)
    expect(card.journey_log.show_journeys.last.entry_station).to eq station
    
  end

  describe '#top_up' do
    
    before do
      
      card.top_up(OysterCard::MIN_FARE)
      card.touch_in(station)
      
    end

    it 'tops up the card by the amount passed to it' do
      
      expect(card.balance).to eq OysterCard::MIN_FARE
      
    end

    it 'raises an error if balance is exceed' do
      
      expect{card.top_up(OysterCard::MAX_BALANCE)}.to raise_error "Maximum balance of #{OysterCard::MAX_BALANCE} exceed"
      
    end 
  end

  describe '#touch_in' do

    it 'shows that you are in_journey when you touch in' do
      
      card.top_up(OysterCard::MIN_FARE)
      card.touch_in(station)
      expect(card).to be_in_journey
      
    end

    it 'raises an error if you touch in without sufficient funds' do
      
      expect{card.touch_in(station)}.to raise_error 'Insufficient funds'
      
    end
  end

  describe '#touch_out' do
    
    before do
      card.top_up(20)
      
    end
    
    it 'shows that you are not in_journey when you touch out' do
      
      card.touch_in(station)
      card.touch_out(station)
      expect(card).not_to be_in_journey
      
    end
    

    it 'deducts min fare when touching out' do
      
      card.touch_in(station)
      expect{card.touch_out(station)}.to change{card.balance}.by -OysterCard::MIN_FARE
      
    end
    
    
    it 'deducts a penalty when not touched in' do
      
      expect{ card.touch_out(station) }.to change{ card.balance }.by (-6)
      
    end
  end

  describe '#deduct' do

    it 'deducts amount from the balance' do
      card.top_up(OysterCard::MIN_FARE)
      card.touch_in(station)
      expect{card.touch_out(station)}.to change{card.balance}.from(OysterCard::MIN_FARE).to(0)
    end
  end

  it 'remembers the entry station' do

    card.top_up(OysterCard::MIN_FARE)
    card.touch_in(station)
    expect(card.journey_log.current.entry_station).to eq station
  end
  
  
end
