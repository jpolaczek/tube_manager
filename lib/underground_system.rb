
require 'repositories/checkin'

class UndergroundSystem
  def initialize(db)
    @db = db
  end

  def check_in(id, station_name, time)
    checkin_validator.call!(id, station_name, time)
    checkin_repository.create(id, station_name, time)
  end

  def check_out(id, station_name, time)
  end

  def get_average_time(start_station, end_station)
  end

  private

  def checkin_repository
    Repositories::CheckIn.new(db)
  end

  def checkin_validator
    @checkin_validator ||= Validators::CheckIn.new
  end
  
  attr_reader :db
end
