CREATE TABLE casters (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  twitch_username TEXT,
  permission BOOLEAN
)
