CREATE TABLE players (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  discord TEXT,
  nickname TEXT,
  dota_player_id TEXT,
  rank TEXT,
  mmr INTEGER,
  pos_1_pref INTEGER,
  pos_2_pref INTEGER,
  pos_3_pref INTEGER,
  pos_4_pref INTEGER,
  pos_5_pref INTEGER,
  stand_in BOOLEAN,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
)
