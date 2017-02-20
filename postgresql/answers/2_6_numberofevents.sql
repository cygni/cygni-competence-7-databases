CREATE OR REPLACE FUNCTION numberOfEvents()
  RETURNS INTEGER AS $total$
DECLARE
  total INTEGER;
BEGIN
  SELECT count(*)
  INTO total
  FROM events;
  RETURN total;
END;
$total$ LANGUAGE plpgsql;

SELECT numberOfEvents();