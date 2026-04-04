CREATE TABLE match_players (
  id SERIAL PRIMARY KEY,
  match_id BIGINT REFERENCES matches(match_id),
  slot_id INTEGER,
  account_id BIGINT,
  player_name TEXT,
  hero_name TEXT,
  team TEXT CHECK (team IN ('radiant', 'dire')),
  lane_role INTEGER,
  kills INTEGER,
  deaths INTEGER,
  assists INTEGER,
  net_worth INTEGER,
  last_hits INTEGER,
  denies INTEGER,
  total_damage INTEGER
)
