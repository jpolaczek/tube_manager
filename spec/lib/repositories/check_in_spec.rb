require 'spec_helper'
require 'sqlite3'
require "#{$root}/lib/repositories/base"
require "#{$root}/lib/repositories/check_in"

RSpec.describe Repositories::CheckIn do
    let(:db) { SQLite3::Database.open 'tech_tests_spec.db' }
    let(:repo) { Repositories::CheckIn.new(db) }

    describe "#create" do

        before { db.execute("DELETE FROM checkins;") }
        after  { db.execute("DELETE FROM checkins;") }

        subject { repo.create(1, 'Madrid', 2) }

        it "should save the given data" do
            subject
            expect(db.execute("SELECT city, user_id, time FROM checkins;")).to eq(
                [['Madrid', 1, 2]]
            )
        end
    end
end
