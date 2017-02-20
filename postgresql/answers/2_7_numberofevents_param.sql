CREATE OR REPLACE FUNCTION numberOfEvents(country_code VARCHAR(2))
  RETURNS INTEGER AS $total$
DECLARE
  total INTEGER;
BEGIN
  SELECT count(e.*)
  INTO total
  FROM events e
    INNER JOIN venues v ON v.venue_id = e.venue_id
  WHERE v.country_code = numberOfEvents.country_code;
  RETURN total;
END;
$total$ LANGUAGE plpgsql;

SELECT numberOfEvents('se');