CREATE TABLE db.casters (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES db.users(id),
  twitch_username TEXT,
  permission BOOLEAN
)
