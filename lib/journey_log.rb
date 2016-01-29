class JourneyLog
  
  attr_accessor :current
  
  def initialize
    @journeys = []
    @current = Journey.new
  end
  
  def record_history(current)
    journeys << current
  end
  
  def show_journeys
    journeys
  end
  
  def start_journey(entry_station)
    self.current = Journey.new
    self.current.entry_station = entry_station
  end
  
  def end_journey(exit_station)
    self.current.exit_station = exit_station
    record_history(current)
    self.current.complete = true
  end
  
  private 
  
  attr_reader :journeys
end