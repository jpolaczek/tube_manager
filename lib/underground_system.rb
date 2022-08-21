require "#{$root}/lib/repositories/check_in"
require "#{$root}/lib/validators/check_in"
require "#{$root}/lib/repositories/check_out"

class UndergroundSystem
  def initialize(db)
    @db = db
  end

  def check_in(id, station_name, time)
    return unless checkin_validator.valid?(id, station_name, time, checkin_repository.find_unfinished_checkin(id))
    
    checkin_repository.create(id, station_name, time)
  end

  def check_out(id, station_name, time)
    return unless unfinishied_checkin_id = checkin_repository.find_unfinished_checkin(id)

    checkin_repository.update_checkin(
      unfinishied_checkin_id,
      checkout_repository.create(id, station_name, time)
    )
  end

  def get_average_time(start_station, end_station)
    travel_repository.get_average_time_for_stations(start_station, end_station)
  end

  private

  def checkin_repository
    @checkin_repository ||= Repositories::CheckIn.new(db)
  end

  def checkout_repository
    @checkout_repository ||= Repositories::CheckOut.new(db)
  end

  def checkin_validator
    @checkin_validator ||= Validators::CheckIn.new
  end

  def travel_repository
    @travel_repository ||= Repositories::Travel.new(db)
  end
  
  attr_reader :db
end
