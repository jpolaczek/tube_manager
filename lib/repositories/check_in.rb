module Repositories
  class CheckIn < Base
    def create(user_id, city, time)
      db.execute("INSERT INTO checkins (user_id, city, time) VALUES (?, ?, ?)", user_id, city, time)
    end
  end
end
