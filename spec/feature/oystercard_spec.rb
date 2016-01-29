require 'oystercard'

describe 'Oytercard features' do
  
  describe 'touchin out without touching in' do
    
    it 'deducts a penalty' do
    card = Oystercard.new
    card.top_up 20
    
    expect{ card.touch_out Station.new("Victoria", 1) }.to change{ card.balance }.by (-6)
   end
  end
  
  describe 'fare changes based on station zones' do
    
    subject(:card) { Oystercard.new }
    
    before do
      card.top_up 20
      card.touch_in(Station.new("Northolth", 4))    
    end
    
    it 'deducts 1 when gone from zone 4 to 4' do
      
      expect{ card.touch_out(Station.new("Northolth", 4)) }.to change{ card.balance }.by -1    
    end
    
    it 'deducts 4 when gone from zone 4 to 1' do

      expect{ card.touch_out(Station.new("Piccadilly", 1)) }.to change{ card.balance }.by -4    
    end
    
  end
  
end
