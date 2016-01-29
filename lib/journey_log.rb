class JourneyLog
  attr_reader :history
#  attr_accessor :record_history
  attr_writer :journey
  
  def initialize
    @history = []
  end
  
  def record_history(journey)
    history << journey
  end
  
  def start_journey(entry_station)
    journey = Journey.new
    journey.entry_station = entry_station
  end
  
  def end_journey(exit_station)
    journey.exit_station = exit_station
    record_history(journey)
    journey.complete = true
  end
end