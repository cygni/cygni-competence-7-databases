WITH categorized_movies AS (
    SELECT
      m.title,
      array_agg(g.name) AS categories
    FROM movies m, genres g
    WHERE cube_ll_coord(m.genre, g.position) > 0
    GROUP BY m.title
)
SELECT title
FROM categorized_movies
WHERE categories @> ARRAY ['Action', 'SciFi'];
