
class UndergroundSystem
  def initialize(db)
    @db = db
  end

  def check_in(id, station_name, time)
  end

  def check_out(id, station_name, time)
  end

  def get_average_time(start_station, end_station)
  end

  private
  
  attr_reader :db
end
