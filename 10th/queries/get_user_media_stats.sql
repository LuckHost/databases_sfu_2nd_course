SELECT 
    mt.name AS media_type,
    COUNT(m.media_id) AS count,
    pg_size_pretty(SUM(m.file_size)) AS total_size,
    ROUND(AVG(m.file_size) / 1024) AS avg_size_kb
FROM 
    media m
JOIN 
    media_types mt ON m.type_id = mt.type_id
WHERE 
    m.user_id = 1
GROUP BY 
    mt.name
ORDER BY 
    count DESC;