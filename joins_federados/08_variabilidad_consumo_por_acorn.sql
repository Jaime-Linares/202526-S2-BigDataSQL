SELECT
    h.acorn_grouped,
    ROUND(AVG(d.energy_std), 4) AS avg_desviacion,
    ROUND(AVG(d.energy_max - d.energy_min), 4) AS avg_rango,
    ROUND(AVG(d.energy_max), 4) AS avg_pico_maximo
FROM iceberg.default.daily_dataset d
JOIN postgres.public.households h ON d.lclid = h.lclid
GROUP BY h.acorn_grouped
ORDER BY avg_desviacion DESC;