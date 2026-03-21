SELECT
    d.lclid,
    h.acorn_grouped,
    h.stdortou,
    ROUND(SUM(d.energy_sum), 2) AS total_energy,
    COUNT(d.day) AS dias_medidos
FROM iceberg.default.daily_dataset d
JOIN postgres.public.households h ON d.lclid = h.lclid
GROUP BY d.lclid, h.acorn_grouped, h.stdortou
ORDER BY total_energy DESC
LIMIT 10;