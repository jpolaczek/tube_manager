module Repositories
  class Base
    def initialize(db)
      @db = db
    end

    private

    attr_reader :db
  end
end
