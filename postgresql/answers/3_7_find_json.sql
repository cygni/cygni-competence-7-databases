SELECT (json -> 'title') AS title
FROM movies_json
WHERE json @> '{"movie_id": 1}';

-- Optional: Create an index on the json column
DROP INDEX IF EXISTS idx_json;
CREATE INDEX idx_json
  ON movies_json USING GIN (json);
