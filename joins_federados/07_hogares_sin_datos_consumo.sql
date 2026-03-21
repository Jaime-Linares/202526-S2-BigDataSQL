SELECT
    h.lclid,
    h.acorn_grouped,
    h.stdortou
FROM postgres.public.households h
LEFT JOIN iceberg.default.daily_dataset d ON h.lclid = d.lclid
WHERE d.lclid IS NULL;