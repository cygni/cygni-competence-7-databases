-- find the top 5 best ranked movies
WITH ranked_movies AS (
    SELECT
      m.title,
      g.name                             AS genre,
      cube_ll_coord(m.genre, g.position) AS score,
      avg(cube_ll_coord(m.genre, g.position)) OVER (PARTITION BY m.title)        AS average
    FROM movies m, genres g
    WHERE cube_ll_coord(m.genre, g.position) > 0 -- skip movies with 0 as score
    ORDER BY average DESC
),
    top_movies AS (
      SELECT
        title,
        max(average) AS score
      FROM ranked_movies
      GROUP BY title
      ORDER BY score DESC
  )
SELECT *
FROM top_movies
LIMIT 5;