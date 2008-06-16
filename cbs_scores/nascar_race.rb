class NascarRace
  attr_accessor :lead_changes, :laps_completed, :race_status, 
                :laps_under_caution, :race_track, :race_series, 
                :leaders, :race_name, :drivers
  
  def initialize
    self.drivers = []
  end
  
  def completed?
    self.completed
  end  
  
end
