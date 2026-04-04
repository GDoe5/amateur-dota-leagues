CREATE TABLE match_draft (
  id SERIAL PRIMARY KEY,
  match_id BIGINT REFERENCES matches(match_id),
  hero_name TEXT,
  is_pick TEXT CHECK (is_pick IN ('pick', 'ban')),
  team TEXT CHECK (team IN ('radiant', 'dire')),
  draft_order INTEGER
)
