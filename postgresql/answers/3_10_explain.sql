--uuid column: seq scan vs index scan
EXPLAIN ANALYZE SELECT *
                FROM cygnus
                WHERE uuid = '8a91e794-e5fd-11e6-983d-0242ac110002';

DROP INDEX IF EXISTS idx_cygnus_uuid;
CREATE INDEX idx_cygnus_uuid
  ON cygnus (uuid);

--point (10 closest points)
EXPLAIN ANALYZE SELECT *
                FROM cygnus
                ORDER BY point <-> POINT '(105,200)'
                LIMIT 10;

DROP INDEX IF EXISTS idx_cygnus_point;
CREATE INDEX idx_cygnus_point
  ON cygnus USING GIST (point);