SELECT
    h.acorn_grouped,
    ROUND(AVG(CASE WHEN MONTH(CAST(d.day AS DATE)) IN (12, 1, 2) THEN d.energy_sum END), 4) AS avg_invierno,
    ROUND(AVG(CASE WHEN MONTH(CAST(d.day AS DATE)) IN (6, 7, 8) THEN d.energy_sum END), 4) AS avg_verano,
    ROUND(
        AVG(CASE WHEN MONTH(CAST(d.day AS DATE)) IN (12, 1, 2) THEN d.energy_sum END) -
        AVG(CASE WHEN MONTH(CAST(d.day AS DATE)) IN (6, 7, 8) THEN d.energy_sum END),
    4) AS diferencia
FROM iceberg.default.daily_dataset d
JOIN postgres.public.households h ON d.lclid = h.lclid
GROUP BY h.acorn_grouped
ORDER BY diferencia DESC;