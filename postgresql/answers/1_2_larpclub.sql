SELECT c.country_name
FROM events e
  INNER JOIN venues v ON e.venue_id = v.venue_id
  INNER JOIN countries c ON v.country_code = c.country_code
WHERE e.title = 'LARP Club';
