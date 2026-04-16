CREATE TABLE db.tournament_series (
  id SERIAL PRIMARY KEY,
  tournament_id INTEGER REFERENCES db.tournaments(id),
  bracket_series_id INTEGER REFERENCES db.bracket_series(id),
  series_number INTEGER,
  left_team_id INTEGER REFERENCES db.teams(id),
  right_team_id INTEGER REFERENCES db.teams(id),
  caster_id INTEGER REFERENCES db.casters(id),
  cocaster_id INTEGER REFERENCES db.casters(id),
  series_format INTEGER CHECK (series_format IN (1, 2, 3)),
  scheduled_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  left_outcome TEXT CHECK (left_outcome IN ('draw', 'win', 'loss')),
  right_outcome TEXT CHECK (right_outcome IN ('draw', 'win', 'loss'))
)
