class BasketballGame
  attr_accessor :team1, :team2, :time_left, :completed, :started
  
  def initialize
    self.team1 = {}
    self.team2 = {}
  end
  
  def completed?
    self.completed
  end

  def started?
    self.started
  end

  def current?
    (self.started? && !self.completed?)
  end
  
  def upcoming?
    (!self.started? && !self.completed?)
  end
  
  def status
    return 0 if current?
    return 1 if upcoming?
    return 2 if completed?
  end
  
  def to_json(*a)
    {
      :team1 => self.team1,
      :team2 => self.team2,
      :time_left => self.time_left,
      :status => self.status,
    }.to_json(*a)
  end
  
  
  
end
