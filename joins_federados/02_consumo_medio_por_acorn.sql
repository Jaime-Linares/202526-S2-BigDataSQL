SELECT 
    h.acorn_grouped,
    ROUND(AVG(d.energy_sum), 4) AS avg_energy_sum,
    ROUND(AVG(d.energy_mean), 4) AS avg_energy_mean,
    COUNT(DISTINCT d.lclid) AS num_hogares
FROM iceberg.default.daily_dataset d
JOIN postgres.public.households h ON d.lclid = h.lclid
GROUP BY h.acorn_grouped
ORDER BY avg_energy_sum DESC;