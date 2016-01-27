class Journey
  
  MIN_FARE = 1
  PENALTY_FARE = 6
  
  attr_writer :entry_station
   
  def initialize 
    @journey = { }
  end
  
  def fare(entry_station, exit_station)
    #(exit_station.zone - entry_station.zone).abs 
    MIN_FARE
  end
  
end