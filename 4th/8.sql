-- все самолеты и  все рейсы, включая те самолеты, 
-- которые не выполняли рейсы, и те рейсы, для которых 
-- нет информации о самолете
SELECT 
    a.aircraft_code,
    a.model AS aircraft_model,
    f.flight_id,
    f.flight_no,
    f.departure_airport,
    f.arrival_airport,
    f.scheduled_departure
FROM 
    aircrafts a
FULL OUTER JOIN 
    flights f ON a.aircraft_code = f.aircraft_code
ORDER BY 
    COALESCE(a.aircraft_code, f.aircraft_code),
    f.scheduled_departure;

-- связь между рейсами и посадочными талонами, 
-- включая все рейсы без посадочных талонов и 
-- все посадочные талоны без рейсов (что маловероятно, 
-- но возможно при ошибках в данных)
SELECT 
    f.flight_id,
    f.flight_no,
    f.departure_airport,
    f.arrival_airport,
    bp.ticket_no,
    bp.boarding_no,
    bp.seat_no
FROM 
    flights f
FULL OUTER JOIN 
    boarding_passes bp ON f.flight_id = bp.flight_id
ORDER BY 
    COALESCE(f.flight_id, bp.flight_id),
    bp.boarding_no;

-- все несоответствия между билетами и их перелетами
SELECT 
    t.ticket_no AS ticket_only,
    tf.ticket_no AS ticket_flight_only,
    t.passenger_name,
    tf.flight_id
FROM 
    tickets t
FULL OUTER JOIN 
    ticket_flights tf ON t.ticket_no = tf.ticket_no
WHERE 
    t.ticket_no IS NULL OR tf.ticket_no IS NULL
ORDER BY 
    COALESCE(t.ticket_no, tf.ticket_no);