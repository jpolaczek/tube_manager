$root = Dir.pwd
require "#{$root}/lib/underground_system.rb"
require 'sqlite3'

tube = UndergroundSystem.new(SQLite3::Database.open('tech_tests.db'))

case ARGV[0]
when 'check_in', 'check_out'
    tube.send(ARGV[0].to_sym, ARGV[1], ARGV[2], ARGV[3])
when 'get_average_time'
    puts tube.send(ARGV[0].to_sym, ARGV[1], ARGV[2])
else
    puts 'incorrect method'
end    
