class Oystercard
  MAX_BALANCE = 90
  MIN_FARE = 1
  attr_reader :balance, :entry_station, :history
  attr_accessor :journey

  def initialize
    @balance = 0
    @history = []
  end

  def top_up(amount)
    raise "Maximum balance of #{MAX_BALANCE} exceed" if max_balance_exceed?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Insufficient funds' if insufficient_fund?
    store_entry_station(entry_station)
  end

  def touch_out(exit_station)
    deduct(MIN_FARE)
    store_journey(exit_station)
  end

  def in_journey?
    !!entry_station
  end

  private

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
    @history << self.journey
    self.journey.entry_station = nil
  end
end
