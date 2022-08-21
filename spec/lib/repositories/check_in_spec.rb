require 'spec_helper'
require 'sqlite3'
require "#{$root}/lib/repositories/base"
require "#{$root}/lib/repositories/check_in"
require "#{$root}/lib/repositories/check_out"

RSpec.describe Repositories::CheckIn do
    before { db.execute('DELETE FROM checkins') }
    after  { db.execute('DELETE FROM checkins') }
    
    let(:db) { SQLite3::Database.open 'tech_tests_spec.db' }
    let(:checkin_repo) { Repositories::CheckIn.new(db) }

    describe '#create' do
        subject { checkin_repo.create(1, 'Madrid', 2) }

        it 'should save the given data' do
            subject
            expect(db.execute('SELECT city, user_id, time FROM checkins')).to eq(
                [['Madrid', 1, 2]]
            )
        end
    end

    describe '#find_unfinished_checkin' do
        subject { checkin_repo.find_unfinished_checkin(1) }

        context 'when unfished checkin exist for id' do
            before { checkin_repo.create(1, 'Madrid', 2) }

            it { is_expected.to eq db.execute('SELECT id FROM checkins').last.last }
        end

        context 'when no unfished checkin exist for id' do
            it { is_expected.to be_nil}
        end


        context 'when fished checkin exist for id' do
            before { checkin_repo.create(1, 'Madrid', 2, 1) }

            it { is_expected.to be_nil }
        end
    end

    describe '#update_checkin' do
        before  { checkin_repo.create(1, 'Madrid', 2,) }
        subject { checkin_repo.update_checkin(checkin_id, 2) }

        let(:checkin_id) { checkin_repo.find_unfinished_checkin(1) }

        it 'updates checkin' do
            expect { subject }
                .to change { db.execute('SELECT checkout_id FROM checkins WHERE id == ?', checkin_id)&.last&.last  }
                .from(nil).to(2)
        end
    end
end
