SELECT 
    departure_city, 
    COUNT(DISTINCT arrival_city) AS unique_directions_count
FROM 
    routes
GROUP BY 
    departure_city
ORDER BY 
    unique_directions_count DESC;

-- Альтернативный вариант с явным указанием направления
SELECT 
    departure_city, 
    COUNT(DISTINCT (departure_city, arrival_city)) AS unique_directions_count
FROM 
    routes
GROUP BY 
    departure_city
ORDER BY 
    unique_directions_count DESC;