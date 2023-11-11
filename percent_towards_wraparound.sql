WITH max_age AS (
    SELECT 2000000000 as max_old_xid
        , setting AS autovacuum_freeze_max_age
        FROM pg_catalog.pg_settings
        WHERE name = 'autovacuum_freeze_max_age' )
, per_database_stats AS (
    SELECT datname
        , m.max_old_xid::int
        , m.autovacuum_freeze_max_age::int
        , age(d.datfrozenxid) AS oldest_current_xid
    FROM pg_catalog.pg_database d
    JOIN max_age m ON (true)
    WHERE d.datallowconn and not d.datistemplate)
SELECT max(ROUND(100*(oldest_current_xid/max_old_xid::float))) AS percent_towards_wraparound
FROM per_database_stats;
