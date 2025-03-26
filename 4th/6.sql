SELECT 
    f.flight_no,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    CASE 
        WHEN a.aircraft_code = '733' THEN 'Boeing 737-300'
        WHEN a.aircraft_code = '735' THEN 'Boeing 737-500'
        WHEN a.aircraft_code = '736' THEN 'Boeing 737-600'
        WHEN a.aircraft_code = '73G' THEN 'Boeing 737-700'
        WHEN a.aircraft_code = '738' THEN 'Boeing 737-800'
        WHEN a.aircraft_code = '739' THEN 'Boeing 737-900'
        WHEN a.aircraft_code = '763' THEN 'Boeing 767-300'
        WHEN a.aircraft_code = '773' THEN 'Boeing 777-300'
        ELSE a.model -- Если код не распознан, выводим как есть
    END AS aircraft_model,
    a.range AS aircraft_range
FROM 
    flights f
JOIN 
    aircrafts a ON f.aircraft_code = a.aircraft_code
JOIN 
    airports dep ON f.departure_airport = dep.airport_code
JOIN 
    airports arr ON f.arrival_airport = arr.airport_code
WHERE 
    a.model LIKE 'Boeing%'
GROUP BY 
    f.flight_no, dep.airport_name, arr.airport_name, a.aircraft_code, a.model, a.range
ORDER BY 
    f.flight_no;