SELECT
    h.acorn_grouped,
    MONTH(CAST(d.day AS DATE)) AS mes,
    ROUND(AVG(d.energy_sum), 4) AS avg_energy_sum
FROM iceberg.default.daily_dataset d
JOIN postgres.public.households h ON d.lclid = h.lclid
GROUP BY h.acorn_grouped, MONTH(CAST(d.day AS DATE))
ORDER BY h.acorn_grouped, mes;