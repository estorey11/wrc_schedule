

class WrcSchedule::Event
  attr_accessor :name, :dates, :winner, :event_url, :results_url, :index, :timezone,  :service_park, :website, :stages, :distance, :cars

  @@all=[]

  def initialize(event_hash)
    event_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
    @cars=[]
  end

  def add_results(results_hash)
    results_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def add_event_info(info_hash)
    info_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.all
    @@all
  end

  def self.find_by_index(index)
    @@all.find{|event| event.index==index}
  end

  def self.max_index
    max=@@all.max{|event| event.index}
    max.index
  end

  def add_car(car)
    cars << car
  end
end
