require './lib/underground_system'
require 'sqlite3'

RSpec.describe UndergroundSystem do
  let(:db) { SQLite3::Database.open 'tech_tests_spec.db' }
  let(:tube) { described_class.new(db) }

  before { db.execute("DELETE FROM checkins;") }
  after  { db.execute("DELETE FROM checkins;") }

  describe '#check_in' do
    subject { tube.check_in(45, 'Layton', 3 ) }
    let(:repo) { Repositories::CheckIn.new(db) }

    it 'saves a checkin to database' do
      subject
      expect(
        db.execute(
          "
            SELECT user_id, city, time FROM checkins
          "
        ).last
      ).to eq [45, 'Layton', 3]
    end

    context 'when closed checkin already exists for user' do
      before { repo.create(45, 'madrid', 3, 1) }

      it 'saves a checkin to database' do
        subject
        expect(
          db.execute(
            "
              SELECT user_id, city, time FROM checkins
            "
          ).last
        ).to eq [45, 'Layton', 3]
      end
    end

    context 'when open checkin already exists for user' do
      before { repo.create(45, 'Layton', 3) }

      it 'does not save a checkin to database' do
        expect { subject }.to_not change { db.execute("SELECT user_id, city, time FROM checkins").count }.from(1)
      end
    end
  end
end
