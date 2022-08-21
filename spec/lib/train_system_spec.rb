require "#{$root}/lib/underground_system"
require 'sqlite3'
require "#{$root}/lib/repositories/travel"

RSpec.describe UndergroundSystem do
  before { db.execute('DELETE FROM checkins') }
  after  { db.execute('DELETE FROM checkins') }

  let(:db)            { SQLite3::Database.open 'tech_tests_spec.db' }
  let(:tube)          { described_class.new(db) }
  let(:checkin_repo)  { Repositories::CheckIn.new(db) }
  let(:begin_station) { 'Layton' }
  let(:end_station)   { 'Madrid' }

  describe '#check_in' do
    subject { tube.check_in(45, begin_station, 3 ) }

    it 'saves a checkin to database' do
      subject
      expect(
        db.execute(
          '
            SELECT user_id, city, time FROM checkins
          '
        ).last
      ).to eq [45, 'Layton', 3]
    end

    context 'when closed checkin already exists for user' do
      before { checkin_repo.create(45, begin_station, 3, 1) }

      it 'saves a checkin to database' do
        subject
        expect(
          db.execute(
            '
              SELECT user_id, city, time FROM checkins
            '
          ).last
        ).to eq [45, begin_station, 3]
      end
    end

    context 'when open checkin already exists for user' do
      before { checkin_repo.create(45, begin_station, 3) }

      it 'does not save a checkin to database' do
        expect { subject }.to_not change { db.execute('SELECT user_id, city, time FROM checkins').count }.from(1)
      end
    end
  end

  describe '#check_out' do
     subject { tube.check_out(1, end_station, 3) }

    before  do
      db.execute('DELETE FROM checkouts;') 
      checkin_repo.create(1, begin_station, 2,)
    end

    after { db.execute('DELETE FROM checkouts;') }

    let(:checkin_id) { checkin_repo.find_unfinished_checkin(1) }
    let(:last_checkout_id) { db.execute('SELECT id FROM checkouts ASC')&.last&.last }

    it 'updates checkin', :aggregate_errors do
      expect(db.execute('SELECT checkout_id FROM checkins ASC WHERE id == ?', checkin_id)&.last&.last).to eq nil
      subject
      expect(db.execute('SELECT checkout_id FROM checkins ASC WHERE id == ?', checkin_id)&.last&.last).to eq last_checkout_id
    end

    it 'create checkout record', :aggregate_errors do
      expect { subject }.to change { db.execute('SELECT id FROM checkouts').count }
          .from(0).to(1)
      expect(db.execute('SELECT city, user_id, time FROM checkouts')).to eq(
          [[end_station, 1, 3]]
      )
    end
  end

  describe '#get_average_time' do
    subject { tube.get_average_time(begin_station, end_station)}

    before do
      allow(Repositories::Travel).to receive(:new).with(db).and_return(travel_repo)
      allow(travel_repo).to receive(:get_average_time_for_stations).with(begin_station, end_station).and_return(average_time)
    end

    let(:travel_repo)  { double 'travel_repo' }
    let(:average_time) { 17.5 }

    it 'calls the travel repository with correct data' do
      expect(subject).to eq "#{begin_station},#{end_station},#{average_time}"
    end
  end
end
