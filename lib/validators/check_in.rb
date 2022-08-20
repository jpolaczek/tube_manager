require "#{$root}/lib/repositories/base"

module Validators
    class CheckIn < Base
        class CheckInValidationError < StandardError
        end

        def call!(user_id, station_name, time)
            @user_id = user_id
            @station_name = station_name
            @time = time
            super
        end

        private

        def valid?
            valid_integer?(user_id) && valid_integer?(time) && valid_string?(station_name)
        end

        def error
            CheckInValidationError
        end

        private
        
        attr_reader :user_id, :station_name, :time
    end
end