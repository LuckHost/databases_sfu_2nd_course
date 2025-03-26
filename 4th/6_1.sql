SELECT 
    r.flight_no,
    r.departure_airport,
    r.arrival_airport,
    CASE 
        WHEN a.aircraft_code = '733' THEN 'Boeing 737-300'
        WHEN a.aircraft_code = '735' THEN 'Boeing 737-500'
        WHEN a.aircraft_code = '736' THEN 'Boeing 737-600'
        WHEN a.aircraft_code = '73G' THEN 'Boeing 737-700'
        WHEN a.aircraft_code = '738' THEN 'Boeing 737-800'
        WHEN a.aircraft_code = '739' THEN 'Boeing 737-900'
        WHEN a.aircraft_code = '763' THEN 'Boeing 767-300'
        WHEN a.aircraft_code = '773' THEN 'Boeing 777-300'
        ELSE a.model
    END AS aircraft_model,
    a.range AS aircraft_range
FROM 
    routes r
JOIN 
    flights f ON r.flight_no = f.flight_no
JOIN 
    aircrafts a ON f.aircraft_code = a.aircraft_code
WHERE 
    a.model LIKE 'Boeing%'
GROUP BY 
    r.flight_no, r.departure_airport, r.arrival_airport, a.aircraft_code, a.model, a.range
ORDER BY 
    r.flight_no;