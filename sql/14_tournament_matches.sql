CREATE TABLE tournament_matches (
  id SERIAL PRIMARY KEY,
  tournament_series_id INTEGER REFERENCES tournament_series(id),
  match_number INTEGER,
  winning_team_id INTEGER REFERENCES teams(id),
  match_id BIGINT REFERENCES matches(match_id)
)
