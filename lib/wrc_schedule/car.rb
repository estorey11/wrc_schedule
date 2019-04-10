class WrcSchedule::Car
  attr_accessor :place, :number, :driver, :codriver, :team, :eligability, :time, :dif_prev, :dif_first, :event

  @@all=[]

  def initialize(event_hash)
    event_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
    @event.add_car(self)
  end
end
