SELECT json ->> 'title' AS title
FROM movies_json, jsonb_array_elements(json -> 'actors') AS actors
WHERE actors ->> 'name' ILIKE 'tom hanks';
