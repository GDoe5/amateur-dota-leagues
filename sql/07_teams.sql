CREATE TABLE teams (
  id SERIAL PRIMARY KEY,
  tournament_id INTEGER REFERENCES tournaments(id),
  team_name TEXT NOT NULL,
  team_short_name TEXT NOT NULL,
  dota_team_id TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  team_group INTEGER,
  team_seed INTEGER
)
