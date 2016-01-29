class Journey 
  
  attr_accessor :entry_station, :exit_station, :complete
  
  PENALTY_FARE = 6
  

  def initialize
    @complete = false
  end
  
  def fare
    return PENALTY_FARE unless complete?
    calculate_fare
  end
  
  private
  
  def calculate_fare
    (self.entry_station.zone - self.exit_station.zone).abs + 1
  end
  
  def complete?
   @complete
  end
end