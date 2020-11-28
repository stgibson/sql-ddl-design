DROP DATABASE IF EXISTS craigslist;

CREATE DATABASE craigslist;

\c craigslist

CREATE TABLE regions (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE locations (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  region_id INTEGER REFERENCES regions ON DELETE CASCADE
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  preferred_region_id INTEGER REFERENCES regions ON DELETE CASCADE
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title TEXT UNIQUE NOT NULL,
  content TEXT NOT NULL,
  user_id INTEGER REFERENCES users ON DELETE CASCADE,
  location_id INTEGER REFERENCES locations ON DELETE CASCADE
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE post_categories (
  id SERIAL PRIMARY KEY,
  post_id INTEGER REFERENCES posts ON DELETE CASCADE,
  category_id INTEGER REFERENCES categories ON DELETE CASCADE
);

INSERT INTO regions (name) VALUES ('San Francisco'), ('Atlanta'), ('Seattle');

INSERT INTO locations (name, region_id) VALUES
  ('San Ramon', 1), ('San Francisco', 1), ('Miami', 2), ('Seattle', 3);

INSERT INTO users (name, preferred_region_id) VALUES
  ('Sean Gibson', 1),
  ('Stanley Kubrick', 2),
  ('Alfred Hitchcock', 1),
  ('Steven Spielberg', 3);

INSERT INTO posts (title, content, user_id, location_id) VALUES
  ('TKD', 'TKD is fun', 1, 1),
  ('Jupiter', 'Jupiter has many moons', 2, 3),
  ('Suspense', 'There is no terror in the bang', 3, 2),
  ('UFOs', 'Where do they come from?', 4, 4);

INSERT INTO categories (name) VALUES ('sports'), ('science'), ('movies');

INSERT INTO post_categories (post_id, category_id) VALUES
  (1, 1), (2, 2), (2, 3), (3, 3), (4, 2), (4, 3);

-- get users and preferred regions
SELECT u.name AS users, r.name AS regions FROM users u JOIN regions r ON
  u.preferred_region_id = r.id;

-- get each post with its title, content, creator, location and region created
SELECT p.title AS titles, p.content AS contents, u.name AS users, l.name AS
  locations, r.name AS regions FROM posts p JOIN users u ON p.user_id = u.id
  JOIN locations l ON p.location_id = l.id JOIN regions r ON
  l.region_id = r.id;

-- get each post with its title, content, and category
SELECT c.name AS categories, p.title AS titles, p.content AS contents FROM
  categories c JOIN post_categories pc ON c.id = pc.category_id JOIN posts p ON
  pc.post_id = p.id;