CREATE TABLE db.bracket_series (
  id SERIAL PRIMARY KEY,
  bracket_format_id INTEGER REFERENCES db.bracket_formats(id),
  status TEXT NOT NULL,
  series_number INTEGER NOT NULL,
  left_match INTEGER,
  left_outcome TEXT CHECK (left_outcome IN ('seed', 'win', 'loss')),
  right_match INTEGER,
  right_outcome TEXT CHECK (right_outcome IN ('seed', 'win', 'loss')),
  bracket_name TEXT,
  round_name TEXT
)
