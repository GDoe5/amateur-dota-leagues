CREATE TABLE db.tournament_matches (
  id SERIAL PRIMARY KEY,
  tournament_series_id INTEGER REFERENCES db.tournament_series(id),
  match_number INTEGER,
  winning_team_id INTEGER REFERENCES db.teams(id),
  match_id BIGINT REFERENCES db.matches(match_id)
)
