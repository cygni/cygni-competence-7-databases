CREATE EXTENSION IF NOT EXISTS plv8;

DROP FUNCTION IF EXISTS numberofEvents_js();

CREATE FUNCTION numberofEvents_js()
  RETURNS TEXT AS $$
    var events = plv8.execute('SELECT * FROM events');
    return events.length;
$$ LANGUAGE plv8 IMMUTABLE STRICT;

SELECT numberOfEvents_js();