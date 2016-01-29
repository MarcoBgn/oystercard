require_relative "station"
require_relative "journey"

class Oystercard
  MAX_BALANCE = 90
  MIN_FARE = 1
  attr_reader :balance, :entry_station, :history
  attr_accessor :journey

  def initialize
    @balance = 0
    @history = []
    @journey = Journey.new
  end

  def top_up(amount)
    raise "Maximum balance of #{MAX_BALANCE} exceed" if max_balance_exceed?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
     record_incomplete if double_touch_in?
     raise 'Insufficient funds' if insufficient_fund?
     store_entry_station(entry_station)
  end

  def touch_out(exit_station)
     return record_incomplete(true) if double_touch_out?
     store_journey(exit_station)
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
    record_history
  end
  
  def no_touch_out  
    deduct(self.journey.fare) 
    self.journey.entry_station = "No Touch In"
    record_history 
  end
  
  def record_history
    @history << self.journey
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

  def store_entry_station(entry_station)
    self.journey = Journey.new
    self.journey.entry_station = entry_station
  end

  def store_journey(exit_station)
    self.journey.exit_station = exit_station
    record_history
    self.journey.complete = true
  end
end
