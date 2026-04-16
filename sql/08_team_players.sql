CREATE TABLE db.team_players (
  id SERIAL PRIMARY KEY,
  team_id INTEGER REFERENCES db.teams(id),
  player_id INTEGER REFERENCES db.players(id),
  is_captain BOOLEAN,
  status TEXT NOT NULL,
  updated_at TIMESTAMP
)
