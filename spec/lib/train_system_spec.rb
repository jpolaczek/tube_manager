require './lib/underground_system'
require 'sqlite3'

RSpec.describe UndergroundSystem do
  let(:db) { SQLite3::Database.open 'tech_tests_spec.db' }
  let(:tube) { described_class.new(db) }

  before { db.execute("DELETE FROM checkins;") }
  after  { db.execute("DELETE FROM checkins;") }
  let(:checkin_repo) { Repositories::CheckIn.new(db) }

  describe '#check_in' do
    subject { tube.check_in(45, 'Layton', 3 ) }

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
      before { checkin_repo.create(45, 'madrid', 3, 1) }

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
      before { checkin_repo.create(45, 'Layton', 3) }

      it 'does not save a checkin to database' do
        expect { subject }.to_not change { db.execute("SELECT user_id, city, time FROM checkins").count }.from(1)
      end
    end
  end

  describe '#check_out' do
    before  do
      db.execute("DELETE FROM checkouts;") 
      checkin_repo.create(1, 'Madrid', 2,)
    end
    after { db.execute("DELETE FROM checkouts;") }
    subject { tube.check_out(1, 'Layton', 3) }

    let(:checkin_id) { checkin_repo.find_unfinished_checkin(1) }
    let(:last_checkout_id) { db.execute("SELECT id FROM checkouts ASC")&.last&.last }

    it 'updates checkin', :aggregate_errors do
      expect(db.execute("SELECT checkout_id FROM checkins ASC WHERE id == ?", checkin_id)&.last&.last).to eq nil
      subject
      expect(db.execute("SELECT checkout_id FROM checkins ASC WHERE id == ?", checkin_id)&.last&.last).to eq last_checkout_id
    end

    it "create checkout record", :aggregate_errors do
      expect { subject }.to change { db.execute("SELECT id FROM checkouts").count }
          .from(0).to(1)
      expect(db.execute("SELECT city, user_id, time FROM checkouts")).to eq(
          [['Layton', 1, 3]]
      )
    end
  end
end
