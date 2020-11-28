DROP DATABASE IF EXISTS medical_center;

CREATE DATABASE medical_center;

\c medical_center

CREATE TABLE medical_center (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE doctors (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  medical_center_id INTEGER REFERENCES medical_center ON DELETE CASCADE
);

CREATE TABLE patients (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE diseases (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE visits (
  id SERIAL PRIMARY KEY,
  doctor_id INTEGER REFERENCES doctors ON DELETE CASCADE,
  patient_id INTEGER REFERENCES patients ON DELETE CASCADE
);

CREATE TABLE diagnoses (
  id SERIAL PRIMARY KEY,
  visit_id INTEGER REFERENCES visits ON DELETE CASCADE,
  disease_id INTEGER REFERENCES diagnoses ON DELETE CASCADE
);

INSERT INTO medical_center (name) VALUES ('John Hopkins');

INSERT INTO doctors (name, medical_center_id) VALUES
  ('John Adams', 1),
  ('Albert Einstein', 1),
  ('Michio Kaku', 1);

INSERT INTO patients (name) VALUES
  ('Sean Gibson'),
  ('Stanley Kubrick'),
  ('Alfred Hitchcock');

INSERT INTO diseases (name) VALUES
  ('allergies'),
  ('diabetes'),
  ('arthritis'),
  ('stomach flu');

INSERT INTO visits (doctor_id, patient_id) VALUES
  (1, 1),
  (2, 1),
  (1, 2),
  (2, 3),
  (3, 3);

INSERT INTO diagnoses (visit_id, disease_id) VALUES
  (1, 1),
  (2, 1),
  (2, 4),
  (3, 2),
  (4, 3),
  (5, 3),
  (5, 4);

-- gets the name of the medical center, doctor, patient, and disease for 1
-- diagnosis for 1 visit
SELECT mc.name AS medical_center, doc.name AS doctor, p.name AS patient, dis.name AS disease FROM medical_center mc JOIN doctors doc ON mc.id = doc.medical_center_id JOIN visits v ON doc.id = v.doctor_id JOIN patients p ON v.patient_id = p.id JOIN diagnoses dia ON v.id = dia.visit_id JOIN diseases dis ON dia.disease_id = dis.id;