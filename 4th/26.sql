WITH flight_passengers AS (
    SELECT 
        t.passenger_name,
        b.seat_no,
        t.contact_data->>'email' AS email,
        tf.fare_conditions
    FROM ticket_flights tf
    JOIN tickets t ON tf.ticket_no = t.ticket_no
    JOIN boarding_passes b ON tf.ticket_no = b.ticket_no AND tf.flight_id = b.flight_id
    WHERE tf.flight_id = 27584
)
SELECT 
    s.seat_no,
    fp.passenger_name,
    fp.email,
    COALESCE(fp.fare_conditions, s.fare_conditions) AS fare_conditions
FROM seats s
LEFT OUTER JOIN flight_passengers fp ON s.seat_no = fp.seat_no
WHERE s.aircraft_code = 'SU9'
ORDER BY
    CAST(SUBSTRING(s.seat_no FROM '^[0-9]+') AS INTEGER),
    SUBSTRING(s.seat_no FROM '[A-Za-z]+$');