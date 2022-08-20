module Validators
    class Base
        def call!(*args)
            raise error unless valid?
        end

        private

        def valid_integer?(val)
            begin
                Integer(val)
            rescue TypeError, ArgumentError
                false
            end   
        end

        def valid_string?(val)
            val.is_a?(String)  
        end
    end
end