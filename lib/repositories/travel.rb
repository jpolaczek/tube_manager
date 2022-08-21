require "#{$root}/lib/repositories/base"

module Repositories
  class Travel < Base
    def get_average_time_for_stations(start_station, end_station)
        db.execute(
            "
                SELECT AVG(checkouts.time - checkins.time) FROM checkins
                JOIN checkouts ON checkins.checkout_id = checkouts.id
                WHERE checkins.city == ? AND checkouts.city == ?

            ", start_station, end_station
        )&.last&.last
    end
  end
end
