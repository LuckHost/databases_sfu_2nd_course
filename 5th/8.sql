-- Создаем новую версию таблицы с учетом классов обслуживания
CREATE TABLE tickets_directions_by_class (
    departure_city text NOT NULL,
    arrival_city text NOT NULL,
    fare_conditions text NOT NULL CHECK (fare_conditions IN ('Economy', 'Business', 'Comfort')),
    last_ticket_time timestamp with time zone,
    tickets_num integer DEFAULT 0,
    PRIMARY KEY (departure_city, arrival_city, fare_conditions)
);

-- Переносим данные из старой таблицы (если нужно)
INSERT INTO tickets_directions_by_class
SELECT 
    departure_city, 
    arrival_city, 
    'Economy' AS fare_conditions,  -- Предполагаем, что все были Economy
    last_ticket_time, 
    tickets_num
FROM tickets_directions
WHERE tickets_num > 0;



WITH sell_tickets AS (
    INSERT INTO ticket_flights_tmp
    (ticket_no, flight_id, fare_conditions, amount)
    VALUES 
        ('1234567890123', 13829, 'Economy', 10500),
        ('1234567890123', 4728, 'Business', 15000),
        ('1234567890123', 30523, 'Economy', 3400),
        ('1234567890123', 7757, 'Comfort', 8000),
        ('1234567890123', 30829, 'Economy', 12800)
    RETURNING *
)
INSERT INTO tickets_directions_by_class AS td
    (departure_city, arrival_city, fare_conditions, last_ticket_time, tickets_num)
SELECT 
    f.departure_city,
    f.arrival_city,
    st.fare_conditions,
    current_timestamp,
    COUNT(*) AS new_tickets
FROM 
    sell_tickets st
JOIN 
    flights_v f ON st.flight_id = f.flight_id
GROUP BY 
    f.departure_city, f.arrival_city, st.fare_conditions
ON CONFLICT (departure_city, arrival_city, fare_conditions) 
DO UPDATE SET
    last_ticket_time = EXCLUDED.last_ticket_time,
    tickets_num = td.tickets_num + EXCLUDED.tickets_num;



SELECT 
    departure_city AS dep_city,
    arrival_city AS arr_city,
    fare_conditions AS class,
    last_ticket_time,
    tickets_num AS num
FROM 
    tickets_directions_by_class
WHERE 
    tickets_num > 0
ORDER BY 
    departure_city, arrival_city, fare_conditions;