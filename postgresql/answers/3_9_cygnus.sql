CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS cygnus AS
  SELECT
    generate_series(1, 20000)                           AS id,
    uuid_generate_v1()                                  AS uuid,
    point(ceil(random() * 1000), ceil(random() * 1000)) AS point,
    random() * (TIMESTAMP '2017-02-21 20:00:00' - TIMESTAMP '2017-01-01 00:00:00') +
    TIMESTAMP '2017-01-01 00:00:00'                     AS datetime;

DROP INDEX IF EXISTS idx_cygnus_id;

-- seq scan vs index scan
EXPLAIN ANALYZE SELECT *
                FROM cygnus
                ORDER BY id
                LIMIT 20;

CREATE INDEX idx_cygnus_id
  ON cygnus (id);