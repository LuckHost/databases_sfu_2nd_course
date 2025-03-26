-- Пример 1: Анализ распределения билетов по классам обслуживания
SELECT 
    departure_city,
    COUNT(*) AS total_flights,
    COUNT(*) FILTER (WHERE fare_conditions = 'Economy') AS economy_flights,
    COUNT(*) FILTER (WHERE fare_conditions = 'Comfort') AS comfort_flights,
    COUNT(*) FILTER (WHERE fare_conditions = 'Business') AS business_flights,
    ROUND(100.0 * COUNT(*) FILTER (WHERE fare_conditions = 'Business') / COUNT(*), 2) AS business_percent
FROM 
    ticket_flights tf
JOIN 
    flights f ON tf.flight_id = f.flight_id
JOIN 
    routes r ON f.flight_no = r.flight_no
GROUP BY 
    departure_city
ORDER BY 
    total_flights DESC;

-- Пример 2: Анализ рейсов по дням недели с использованием FILTER
SELECT 
    aircraft_code,
    model,
    COUNT(*) FILTER (WHERE days_of_week @> '{1}'::integer[]) AS monday_flights,
    COUNT(*) FILTER (WHERE days_of_week @> '{2}'::integer[]) AS tuesday_flights,
    COUNT(*) FILTER (WHERE days_of_week @> '{3}'::integer[]) AS wednesday_flights,
    COUNT(*) FILTER (WHERE days_of_week @> '{4}'::integer[]) AS thursday_flights,
    COUNT(*) FILTER (WHERE days_of_week @> '{5}'::integer[]) AS friday_flights,
    COUNT(*) FILTER (WHERE days_of_week @> '{6}'::integer[]) AS saturday_flights,
    COUNT(*) FILTER (WHERE days_of_week @> '{7}'::integer[]) AS sunday_flights
FROM 
    routes r
JOIN 
    flights f ON r.flight_no = f.flight_no
JOIN 
    aircrafts a ON f.aircraft_code = a.aircraft_code
GROUP BY 
    aircraft_code, model;

-- Пример 4: Сравнение заполняемости рейсов по сезонам
SELECT 
    departure_airport,
    COUNT(*) AS total_flights,
    COUNT(*) FILTER (WHERE scheduled_departure BETWEEN '2023-01-01' AND '2023-03-31') AS winter_flights,
    COUNT(*) FILTER (WHERE scheduled_departure BETWEEN '2023-04-01' AND '2023-06-30') AS spring_flights,
    COUNT(*) FILTER (WHERE scheduled_departure BETWEEN '2023-07-01' AND '2023-09-30') AS summer_flights,
    COUNT(*) FILTER (WHERE scheduled_departure BETWEEN '2023-10-01' AND '2023-12-31') AS autumn_flights,
    AVG(EXTRACT(EPOCH FROM (actual_arrival - actual_departure))/60) FILTER (WHERE status = 'Arrived') AS avg_flight_duration_min
FROM 
    flights
WHERE 
    scheduled_departure BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
    departure_airport;