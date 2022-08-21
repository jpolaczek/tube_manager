require 'spec_helper'
require 'sqlite3'
require "#{$root}/lib/repositories/base"
require "#{$root}/lib/repositories/check_out"
require "#{$root}/lib/repositories/check_in"
require "#{$root}/lib/repositories/travel"

RSpec.describe Repositories::Travel do
    let(:db) { SQLite3::Database.open 'tech_tests_spec.db' }
    let(:travel_repo) { Repositories::Travel.new(db) }
    let(:checkin_repo) { Repositories::CheckIn.new(db) }
    let(:checkout_repo) { Repositories::CheckOut.new(db) }

    before do
        db.execute("DELETE FROM checkouts;")
        db.execute("DELETE FROM checkins;")
    end
    after do
        db.execute("DELETE FROM checkouts;")
        db.execute("DELETE FROM checkins;")
    end

    describe "#create" do
        subject { travel_repo.get_average_time_for_stations('Madrid', 'Valencia') }

        context 'when given travel exists' do
            before do
                checkin_repo.create(1, 'Madrid', 2, checkout_repo.create(1, 'Valencia', 12))
                checkin_repo.create(2, 'Madrid', 1, checkout_repo.create(2, 'Valencia', 14))
                checkin_repo.create(3, 'Madrid', 3, checkout_repo.create(3, 'Valencia', 19))
                checkin_repo.create(3, 'Madrid', 3, checkout_repo.create(3, 'Barcelona', 19))
            end


            it "should return the average travel time" do
                expect(subject).to eq(13)
            end
        end

        context 'when unfinished travel exists as well' do
            before do
                checkin_repo.create(1, 'Madrid', 2)
                checkin_repo.create(2, 'Madrid', 1, checkout_repo.create(2, 'Valencia', 14))
                checkin_repo.create(3, 'Madrid', 3, checkout_repo.create(3, 'Valencia', 19))
                checkin_repo.create(3, 'Madrid', 3, checkout_repo.create(3, 'Barcelona', 19))
            end


            it "should return the average travel time" do
                expect(subject).to eq(14.5)
            end
        end

        context 'when no unfinished travel exists' do
            before do
                checkin_repo.create(1, 'Madrid', 2)
                checkin_repo.create(3, 'Madrid', 3, checkout_repo.create(3, 'Barcelona', 19))
            end

            it "should return the average travel time" do
                expect(subject).to eq(nil)
            end

            context 'when no travel exists' do
                it "should return the average travel time" do
                    expect(subject).to eq(nil)
                end
            end
        end
    end
end
