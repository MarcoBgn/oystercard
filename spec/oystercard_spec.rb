require 'oystercard'

describe Oystercard do

  subject(:card) { described_class.new }
  let(:station)  { double :station }
  let(:station2) { double :station }
  let(:journey) { double :journey }

  before(:each) do
    allow(station).to receive(:name).and_return(station)
    allow(station2).to receive(:name).and_return(station2)
  end


  it 'initializes with a balance of 0' do
    expect(card.balance).to eq 0
  end

  it 'history of journeys is empty when initialized' do
    expect(card.history).to be_empty
  end

  it 'stores one journey in history' do
    card.top_up(Oystercard::MIN_FARE)
    card.touch_in(station)
    card.touch_out(station2)
    expect(card.history.last.entry_station).to eq station
  end

  describe '#top_up' do
    before do
      card.top_up(Oystercard::MIN_FARE)
      card.touch_in(station)
    end

    it 'tops up the card by the amount passed to it' do
      expect(card.balance).to eq Oystercard::MIN_FARE
    end

    it 'raises an error if balance is exceed' do
      expect{card.top_up(Oystercard::MAX_BALANCE)}.to raise_error "Maximum balance of #{Oystercard::MAX_BALANCE} exceed"
    end
  end

  describe '#touch_in' do
    # In order to get through the barriers.
    # As a customer
    # I need to touch in and out.

    it 'shows that you are in_journey when you touch in' do
      card.top_up(Oystercard::MIN_FARE)
      card.touch_in(station)
      expect(card).to be_in_journey
    end

    # In order to pay for my journey
    # As a customer
    # I need to have the minimum amount (£1) for a single journey.
    it 'raises an error if you touch in without sufficient funds' do
      expect{card.touch_in(station)}.to raise_error 'Insufficient funds'
    end
  end

  describe '#touch_out' do
    before do
      card.top_up(Oystercard::MIN_FARE)
      card.touch_in(station)
    end
    it 'shows that you are not in_journey when you touch out' do
      card.touch_out(station)
      expect(card).not_to be_in_journey
    end

  # In order to pay for my journey
  # As a customer
  # When my journey is complete, I need the correct amount deducted from my card
  it 'deducts min fare when touching out' do
    expect{card.touch_out(station)}.to change{card.balance}.by -Oystercard::MIN_FARE
  end
end

  describe '#deduct' do

  # In order to pay for my journey
  # As a customer
  # I need my fare deducted from my card

    it 'deducts amount from the balance' do
      card.top_up(Oystercard::MIN_FARE)
      card.touch_in(station)
      expect{card.touch_out(station)}.to change{card.balance}.from(Oystercard::MIN_FARE).to(0)
    end
  end

  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from
  it 'remembers the entry station' do

    card.top_up(Oystercard::MIN_FARE)
    card.touch_in(station)
    expect(card.journey.entry_station).to eq station
  end

  it 'resets the entry station when touching out' do
    card.top_up(Oystercard::MIN_FARE)
    card.touch_in(station)
    expect{card.touch_out(station)}.to change{card.journey.entry_station}.to eq nil
  end
end
