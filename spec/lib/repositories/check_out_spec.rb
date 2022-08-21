require 'spec_helper'
require 'sqlite3'
require "#{$root}/lib/repositories/base"
require "#{$root}/lib/repositories/check_out"

RSpec.describe Repositories::CheckOut do
    before { db.execute('DELETE FROM checkouts') }
    after  { db.execute('DELETE FROM checkouts') }

    let(:db) { SQLite3::Database.open 'tech_tests_spec.db' }
    let(:repo) { Repositories::CheckOut.new(db) }

    describe '#create' do
        subject { repo.create(1, 'Madrid', 2) }

        it 'should save the given data', :aggregate_errors do
            expect { subject }.to change { db.execute('SELECT city, user_id, time FROM checkouts').count }
                .from(0).to(1)
            expect(db.execute('SELECT city, user_id, time FROM checkouts')).to eq(
                [['Madrid', 1, 2]]
            )
        end
    end
end
