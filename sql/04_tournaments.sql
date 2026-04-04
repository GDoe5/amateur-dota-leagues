CREATE TABLE tournaments (
  id SERIAL PRIMARY KEY,
  tournament_name TEXT NOT NULL,
  status TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  league_id INTEGER,
  visible_start TIMESTAMP,
  archive_start TIMESTAMP,
  player_signup_start TIMESTAMP,
  player_signup_end TIMESTAMP,
  team_signup_start TIMESTAMP,
  team_signup_end TIMESTAMP,
  tournament_start TIMESTAMP,
  tournament_end TIMESTAMP,
  group_stage_num_groups INTEGER,
  group_stage_num_teams INTEGER,
  main_stage_format_id INTEGER REFERENCES bracket_formats(id)
)
