require_relative "station"
require_relative "journey"
require_relative "journey_log"

class Oystercard
  MAX_BALANCE = 90
  MIN_FARE = 1
  attr_reader :balance, :entry_station, :journey_log
  attr_accessor :journey

  def initialize
    @balance = 0
    @journey_log = JourneyLog.new
    @journey = Journey.new
  end

  def top_up(amount)
    raise "Maximum balance of #{MAX_BALANCE} exceed" if max_balance_exceed?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
     record_incomplete if double_touch_in?
     raise 'Insufficient funds' if insufficient_fund?
     journey_log.start_journey(entry_station)     
  end

  def touch_out(exit_station)
     return record_incomplete(true) if double_touch_out?
     journey_log.end_journey(exit_station)
     deduct(self.journey.fare)
  end

  def in_journey?
    !self.journey.complete
  end

  private
  
  def record_incomplete(exit=false)
   !exit ? no_touch_in : no_touch_out
  end
  
  def no_touch_in
    deduct(self.journey.fare) 
    self.journey.exit_station = "No Touch Out"
    journey_log.record_history(@journey)
  end
  
  def no_touch_out  
    deduct(self.journey.fare) 
    self.journey.entry_station = "No Touch In"
    journey_log.record_history(@journey) 
  end
  
  def double_touch_in?
    self.journey.entry_station != nil && self.journey.exit_station == nil
  end

  def double_touch_out?
    self.journey.entry_station == nil 
  end
  
  def deduct(amount)
    @balance -= amount
  end

  def max_balance_exceed?(amount)
    @balance + amount > MAX_BALANCE
  end

  def insufficient_fund?
    @balance < MIN_FARE
  end
end
