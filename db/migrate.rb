require 'sqlite3'

db = SQLite3::Database.open 'tech_tests.db'
db.execute "
    CREATE TABLE IF NOT EXISTS checkins(
        city TEXT NOT NULL,
        user_id INT NOT NULL,
        time INT NOT NULL,
        checkout_id INT UNIQUE,
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
    )
"
db.execute "
    CREATE TABLE IF NOT EXISTS checkouts(
        city TEXT NOT NULL,
        user_id INT NOT NULL,
        time INT NOT NULL,
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
    )
"

db_test = SQLite3::Database.open 'tech_tests_spec.db'
db_test.execute "
    CREATE TABLE IF NOT EXISTS checkins(
        city TEXT NOT NULL,
        user_id INT NOT NULL,
        time INT NOT NULL,
        checkout_id INT UNIQUE,
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL 
    )
"
db_test.execute "
    CREATE TABLE IF NOT EXISTS checkouts(
        city TEXT NOT NULL,
        user_id INT NOT NULL,
        time INT NOT NULL, 
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL 
    )
"