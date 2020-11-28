DROP DATABASE IF EXISTS soccer_league;

CREATE DATABASE soccer_league;

\c soccer_league;

CREATE TABLE league (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE start_dates (
  id SERIAL PRIMARY KEY,
  date DATE UNIQUE NOT NULL,
  league_id INTEGER REFERENCES league ON DELETE CASCADE
);

CREATE TABLE end_dates (
  id SERIAL PRIMARY KEY,
  date DATE UNIQUE NOT NULL,
  league_id INTEGER REFERENCES league ON DELETE CASCADE
);

CREATE TABLE teams (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  league_id INTEGER REFERENCES league ON DELETE CASCADE
);

CREATE TABLE players (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  team_id INTEGER REFERENCES teams ON DELETE CASCADE
);

CREATE TABLE games (
  id SERIAL PRIMARY KEY,
  team1_id INTEGER REFERENCES teams ON DELETE CASCADE,
  team2_id INTEGER REFERENCES teams ON DELETE CASCADE
);

CREATE TABLE referees (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE goals (
  id SERIAL PRIMARY KEY,
  player_id INTEGER REFERENCES players ON DELETE CASCADE,
  game_id INTEGER REFERENCES games ON DELETE CASCADE
);

CREATE TABLE game_referees (
  id SERIAL PRIMARY KEY,
  game_id INTEGER REFERENCES games ON DELETE CASCADE,
  referee_id INTEGER REFERENCES referees ON DELETE CASCADE
);

INSERT INTO league (name) VALUES ('Major League');

INSERT INTO start_dates (date, league_id) VALUES
  ('2018-03-21', 1), ('2019-03-20', 1);

INSERT INTO end_dates (date, league_id) VALUES
  ('2018-06-21', 1), ('2019-06-20', 1);

INSERT INTO teams (name, league_id) VALUES
  ('team1', 1), ('team2', 1), ('team3', 1), ('team4', 1);

INSERT INTO players (name, team_id) VALUES
  ('Sean Gibson', 1),
  ('Coby Brian', 1),
  ('Stanley Kubrick', 2),
  ('Alfred Hitchcock', 2),
  ('Green Cap', 3),
  ('Red Cap', 4);

INSERT INTO games (team1_id, team2_id) VALUES (1, 2), (3, 4);

INSERT INTO referees (name) VALUES ('referee 1'), ('referee 2'), ('referee 3');

INSERT INTO goals (player_id, game_id) VALUES
  (1, 1), (1, 1), (1, 1), (2, 1), (3, 1), (4, 1), (5, 2), (5, 2), (6, 2);

INSERT INTO game_referees (game_id, referee_id) VALUES
  (1, 1), (1, 2), (2, 2), (2, 3);

-- gets all of the team names from the league and the names of the players
SELECT l.name AS league, t.name AS team_names, p.name AS players FROM league l
  JOIN teams t ON l.id = t.league_id JOIN players p ON t.id = p.team_id;

-- gets all of the goals scored by each player for each game
SELECT p.name AS players, t1.name AS team1, t2.name AS team2 FROM players p
  JOIN goals go ON p.id = go.player_id JOIN games ga ON go.game_id = ga.id JOIN
  teams t1 ON ga.team1_id = t1.id JOIN teams t2 ON ga.team2_id = t2.id;

-- gets all games all the referees took part in
SELECT r.name AS referees, t1.name AS team1, t2.name AS team2 FROM referees r
  JOIN game_referees gr ON r.id = gr.referee_id JOIN games g ON
  gr.game_id = g.id JOIN teams t1 ON g.team1_id = t1.id JOIN teams t2 ON
  g.team2_id = t2.id;

-- gets all of the start for the league
SELECT l.name AS league, sd.date AS start_dates FROM league l JOIN
  start_dates sd ON l.id = sd.league_id;

-- gets all of the start for the league
SELECT l.name AS league, ed.date AS end_dates FROM league l JOIN end_dates ed
  ON l.id = ed.league_id;

SELECT t.name AS teams, COUNT(*) AS goals_made FROM teams t JOIN players p ON
  t.id = p.team_id JOIN goals g ON p.id = g.player_id GROUP BY t.name ORDER BY
  goals_made DESC;