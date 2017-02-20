-- select all comedy movies where arnold is an actor
SELECT m.title
FROM movies m
  INNER JOIN movies_actors ma ON m.movie_id = ma.movie_id
  INNER JOIN actors a ON a.actor_id = ma.actor_id
WHERE a.name ILIKE 'arnold%' AND cube_ll_coord(m.genre, 4) > 0;