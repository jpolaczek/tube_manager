require "#{$root}/lib/repositories/base"

module Repositories
  class CheckOut < Base
    def create(user_id, city, time)
        db.execute(
            '
                INSERT INTO checkouts (
                    user_id,
                    city,
                    time
                ) VALUES (?, ?, ?) RETURNING id
            ', user_id, city, time
        )&.last&.last
    end
  end
end
