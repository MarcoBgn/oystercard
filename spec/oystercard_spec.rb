require 'oystercard'

describe OysterCard do

  subject(:card) { described_class.new}
  let(:station1) { Station.new("Victoria", 1) }
  let(:station2) { Station.new("Kingston", 1) }

  context "card balance" do


	  it 'has a balance of zero' do
	  	expect(card.balance).to eq(0)
	  end

	  it "can top_up the balance" do
	    expect{card.top_up(50)}.to change{ card.balance }.to(50)
	  end

	  it "checks for maximum limit" do
	  	expect{ card.top_up(100) }.to raise_error "Card limit is #{OysterCard::CARD_LIMIT}"
	  end

	end

	context 'card operation' do
    
    before(:each) do
      
      card.top_up(7)
      
    end


		
  describe "#touch_in" do
      
		it 'in_journey is true after touch in' do
			card.touch_in(station1)
			expect(card).to be_in_journey
    end
    
		it "stores the entry station" do
			card.touch_in(station1)
			expect(card.entry_station).to eq station1
		end
    
    it "charges the penalty fare if not touched out" do
      card.touch_in(station1)
      expect(card.touch_in(station2)).to satisfy{ card.history.last.has_value?("No exit station!")}
    end
  end
  
  describe "#touch_out" do
  
	  it "clears entry_station" do
		 card.touch_in(station1)
		 card.touch_out(station1)
		 expect(card.entry_station).to eq nil
	end
  
		it 'in_journey is false after touch out' do
      card.touch_in(station2)
			card.touch_out(station1)
			expect(card).not_to be_in_journey
		end
    
    it 'deducts #{OysterCard::MIN_FARE} fare' do
			card.touch_in(station1)
			expect{ card.touch_out(station1) }.to change{ card.balance }.by(-1)
		end
    
    it 'charges a penalty fare if not touched in' do
      expect(card.touch_out(station1)).to satisfy{ card.history.last.has_key?("No entry station!") }
    end
  end
  
    it 'has an empty history when initialised' do
      expect(card.history).to eq []
    end

    it 'stores the history of the journeys' do
      card.touch_in(station1)
      card.touch_out(station2)
      expect(card.history).to eq [{station1=>station2}]
    end  
  end

	  it "require a minimum fare of 1" do
      expect{ card.touch_in(station1)}.to raise_error "minimum fare is #{OysterCard::MIN_FARE} pound"
    end

end
