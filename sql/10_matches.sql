CREATE TABLE matches (
  league_id INTEGER,
  match_id BIGINT PRIMARY KEY,
  duration_seconds NUMERIC,
  radiant_win BOOLEAN,
  game_mode INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  radiant_team_id BIGINT,
  radiant_team_name TEXT,
  dire_team_id BIGINT,
  dire_team_name TEXT
)
