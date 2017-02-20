SELECT
  c.country_name,
  count(e)
FROM countries c
  JOIN venues v ON v.country_code = c.country_code
  JOIN events e ON e.venue_id = v.venue_id
GROUP BY c.country_name;