INSERT INTO countries (country_code, country_name) VALUES ('se', 'Sweden');

INSERT INTO cities (name, postal_code, country_code)
VALUES
  ('Stockholm', '111 44', 'se'),
  ('Göteborg', '411 08', 'se');

INSERT INTO venues (name, street_address, postal_code, country_code)
VALUES
  ('Cygni AB', 'Jakobsbergsgatan 22', '111 44', 'se'),
  ('Cygni Väst AB', 'St. Nygatan 31', '411 08', 'se');

INSERT INTO events (title, starts, ends, venue_id)
VALUES
  ('Kompetensutveckling postgres, Stockholm', '2017-02-15 17:30:00', '2017-02-15 20:00:00', (SELECT venue_id
                                                                                             FROM venues
                                                                                             WHERE name = 'Cygni AB')),
  ('Kompetensutveckling postgres, Göteborg', '2017-02-21 17:30:00', '2017-02-21 20:00:00', (SELECT venue_id
                                                                                            FROM venues
                                                                                            WHERE
                                                                                              name = 'Cygni Väst AB'));