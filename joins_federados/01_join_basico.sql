SELECT 
    d.lclid,
    h.acorn_grouped,
    d.day,
    d.energy_sum
FROM iceberg.default.daily_dataset d
JOIN postgres.public.households h ON d.lclid = h.lclid
LIMIT 10;