require 'spec_helper'
require 'sqlite3'
require "#{$root}/lib/repositories/base"
require "#{$root}/lib/repositories/check_in"

RSpec.describe Repositories::CheckIn do
    let(:db) { SQLite3::Database.open 'tech_tests_spec.db' }
    let(:repo) { Repositories::CheckIn.new(db) }
    before { db.execute("DELETE FROM checkins;") }
    after  { db.execute("DELETE FROM checkins;") }

    describe "#create" do
        subject { repo.create(1, 'Madrid', 2) }

        it "should save the given data" do
            subject
            expect(db.execute("SELECT city, user_id, time FROM checkins;")).to eq(
                [['Madrid', 1, 2]]
            )
        end
    end

    describe "#find_unfinished_checkin" do
        subject { repo.find_unfinished_checkin(1) }

        context 'when unfished checkin exist for id' do
            before { repo.create(1, 'Madrid', 2) }

            it { is_expected.to eq db.execute("SELECT id FROM checkins;").last.last }
        end

        context 'when no unfished checkin exist for id' do
            it { is_expected.to be_nil}
        end


        context 'when fished checkin exist for id' do
            before { repo.create(1, 'Madrid', 2, 1) }

            it { is_expected.to be_nil}
        end
    end
end
