SELECT
  class.relname     AS tablename,
  namespace.nspname AS schema,
  auth.rolname      AS owner
FROM pg_class class
  INNER JOIN pg_authid auth ON class.relowner = auth.OID
  INNER JOIN pg_namespace namespace ON class.relnamespace = namespace.oid
WHERE class.relkind = 'r' AND auth.rolname = 'postgres' AND namespace.nspname = 'public';