SELECT title
FROM movies
WHERE cube_ll_coord(genre, 1) > 0;

