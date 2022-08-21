module Validators
    class Base
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