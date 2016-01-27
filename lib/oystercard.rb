class OysterCard
  
 CARD_LIMIT = 90
 MIN_FARE = 1
 PENALTY_FARE = 6
 
 attr_reader :balance, :entry_station, :history
 
 def initialize
   @balance = 0
   @history = []
 end

 def top_up(value)
 		balance_expected = @balance + value
 		raise "Card limit is #{CARD_LIMIT}" if balance_expected > CARD_LIMIT
   	@balance += value
 end

 def touch_in(station)
   if in_journey?
    journey(station) 
    
  else
    @entry_station = station 
  	raise "minimum fare is #{MIN_FARE} pound" if @balance < MIN_FARE
  end
 end

 def touch_out(station)
   unless in_journey?
     journey(station, false)
     
   else
     journey = {}
     journey[@entry_station] = station
     fare = Journey.new.fare(@entry_station, station)
     @history << journey
     @entry_station = nil
 	   deduct(MIN_FARE)
   end
 end

 def in_journey?
 	!!entry_station
 end
 

private

 def deduct(value)
   raise "Insufficient funds" if value > @balance
   @balance -= value
 end
 
  def journey(station, entry=true)
   if entry
   deduct(PENALTY_FARE)
   journey = {}
   journey[@entry_station] = "No exit station!"
   @history << journey
   journey 
  else
   deduct(PENALTY_FARE)
   journey = {}
   journey["No entry station!"] = station
   @history << journey
   journey  
  end
 end
 

end
