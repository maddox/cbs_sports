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
  
  
end
