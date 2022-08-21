require "#{$root}/lib/validators/base"

module Validators
    class CheckIn < Base
        def valid?(user_id, station_name, time, earlier_checkin_id=nil)
            valid_integer?(user_id) &&
             valid_integer?(time) &&
             valid_string?(station_name) &&
             earlier_checkin_id.nil?
        end
    end
end