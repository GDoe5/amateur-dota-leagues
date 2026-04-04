import gem
import pandas as pd
from gem.constants import hero_display

def parse_replay(dem_path):
    match = gem.parse(dem_path)

    # matches - one row
    matches = pd.DataFrame([{
        "league_id":        match.leagueid,
        "match_id":         match.match_id,
        "radiant_team_id":  match.radiant_team_id,
        "radiant_team_name":match.radiant_team_name,
        "dire_team_id":     match.dire_Team_id,
        "dire_team_name":   match.dire_team_name,
        "duration_seconds": match.duration_seconds,
        "radiant_win":      match.radiant_win,
        "game_mode":        match.game_mode,
    }])

    # players - one row per player, scalar fields only
    players = pd.DataFrame([{
        "match_id":           match.match_id,
        "slot_id":            p.player_id,
        "account_id":         p.account_id,
        "player_name":        p.player_name,
        "hero_name":          hero_display(p.hero_name),
        "team":               "radiant" if p.team == 2 else "dire",
        "lane_role":          p.lane_role,
        "kills":              p.kills,
        "deaths":             p.deaths,
        "assists":            p.assists,
        "net_worth":          p.net_worth_t_min[-1] if p.net_worth_t_min else 0,
        "last_hits":          p.lh_t_min[-1] if p.lh_t_min else 0,
        "denies":             p.dn_t_min[-1] if p.dn_t_min else 0,
        "total_damage":       sum(p.damage.values()),
        # "damage_physical":    p.damage_by_type.get("physical", 0),
        # "damage_magical":     p.damage_by_type.get("magical", 0),
        # "damage_pure":        p.damage_by_type.get("pure", 0),
    } for p in match.players])

    # draft - one row per pick/ban
    draft = pd.DataFrame([{
        "match_id":  match.match_id,
        "hero_name": hero_display(d.hero_name),
        "is_pick":   "pick" if d.is_pick else "ban",
        "team":      "radiant" if d.team == 2 else "dire",
        "order":     i,
    } for i, d in enumerate(match.draft)])

    # return match

    return matches, players, draft

def parse_replay_full(dem_path):
    match = gem.parse(dem_path)

    return match