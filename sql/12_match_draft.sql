CREATE TABLE match_draft (
  id SERIAL PRIMARY KEY,
  match_id BIGINT REFERENCES matches(match_id),
  hero_name TEXT NOT NULL,
  draft_action TEXT CHECK (draft_action IN ('pick', 'ban')),
  draft_side TEXT CHECK (draft_side IN ('radiant', 'dire')),
  draft_order INTEGER NOT NULL
)
