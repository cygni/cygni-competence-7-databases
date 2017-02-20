DROP TABLE IF EXISTS movies_json;
CREATE TABLE movies_json AS (
  SELECT
    uuid_generate_v1() AS id,
    row_to_json(m)     AS json
  FROM (SELECT
          m.movie_id,
          m.title,
          array_agg(a) AS actors,
          (
            SELECT array_to_json(array_agg(row_to_json(g)))
            FROM (
                   SELECT
                     g.name,
                     cube_ll_coord(m1.genre, g.position) AS score
                   FROM movies m1, genres g
                   WHERE cube_ll_coord(m1.genre, g.position) > 0 AND m1.movie_id = m.movie_id
                 ) g

          )            AS genres
        FROM movies m
          INNER JOIN movies_actors ma ON ma.movie_id = m.movie_id
          INNER JOIN actors a ON a.actor_id = ma.actor_id
        GROUP BY m.movie_id
       ) m
);

ALTER TABLE movies_json ALTER json TYPE JSONB;

SELECT json
FROM movies_json
LIMIT 1;