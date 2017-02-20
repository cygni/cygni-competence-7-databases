SELECT
  extract(YEAR FROM starts) AS year,
  count(*)                  AS events
FROM events
GROUP BY year;