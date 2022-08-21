require "#{$root}/lib/repositories/base"

module Repositories
  class CheckIn < Base
    def create(user_id, city, time, _checkout_id=nil)
      db.execute(
        "
          INSERT INTO checkins (
            user_id,
            city,
            time,
            checkout_id
          ) VALUES (?, ?, ?, ?)
        ", user_id, city, time, _checkout_id
      )
    end

    def find_unfinished_checkin(user_id)
      db.execute(
        "
          SELECT id FROM checkins 
          WHERE checkout_id is null AND user_id == ?
        ", user_id
      )&.last&.last
    end
  end
end
