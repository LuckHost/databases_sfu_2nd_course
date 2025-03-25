WITH total_routes AS (
    SELECT COUNT(*)::numeric AS total FROM routes
)
SELECT 
    a.aircraft_code AS a_code,
    a.model,
    a.aircraft_code AS r_code,
    COUNT(r.aircraft_code) AS num_routes,
    ROUND(COUNT(r.aircraft_code) / (SELECT total FROM total_routes), 3) AS fraction
FROM 
    aircrafts a
LEFT JOIN 
    routes r ON a.aircraft_code = r.aircraft_code
GROUP BY 
    a.aircraft_code, a.model
ORDER BY 
    num_routes DESC;

-- версия с форматированием вывода
WITH 
total_routes AS (
    SELECT COUNT(*)::numeric AS total FROM routes
),
route_stats AS (
    SELECT 
        a.aircraft_code AS a_code,
        a.model,
        a.aircraft_code AS r_code,
        COUNT(r.aircraft_code) AS num_routes
    FROM 
        aircrafts a
    LEFT JOIN 
        routes r ON a.aircraft_code = r.aircraft_code
    GROUP BY 
        a.aircraft_code, a.model
)
SELECT 
    a_code,
    model,
    r_code,
    num_routes,
    CASE 
        WHEN num_routes = 0 THEN '0.000'
        ELSE TO_CHAR(num_routes / (SELECT total FROM total_routes), '0.000')
    END AS fraction
FROM 
    route_stats
ORDER BY 
    num_routes DESC;

-- Альтернативный вариант с использованием оконной функции
SELECT 
    a.aircraft_code AS a_code,
    a.model,
    a.aircraft_code AS r_code,
    COUNT(r.aircraft_code) AS num_routes,
    ROUND(COUNT(r.aircraft_code) / SUM(COUNT(r.aircraft_code)) OVER(), 3) AS fraction
FROM 
    aircrafts a
LEFT JOIN 
    routes r ON a.aircraft_code = r.aircraft_code
GROUP BY 
    a.aircraft_code, a.model
ORDER BY 
    num_routes DESC;