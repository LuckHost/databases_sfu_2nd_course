-- Добавляем столбцы типа jsonb в таблицы

-- Таблица Flights
ALTER TABLE flights ADD COLUMN flight_details jsonb;

-- Таблица Airports
ALTER TABLE airports ADD COLUMN facilities jsonb;

-- Таблица Bookings
ALTER TABLE bookings ADD COLUMN payment_details jsonb;

-- Таблица Boarding_passes
ALTER TABLE boarding_passes ADD COLUMN boarding_info jsonb;

-- Таблица Seats
ALTER TABLE seats ADD COLUMN seat_features jsonb;

-- Обновляем данные для проверки

-- Flights
UPDATE flights
SET flight_details =
'{ "delay_reason": "weather",
   "delay_minutes": 45
}'::jsonb
WHERE flight_id = 1;

-- Airports
UPDATE airports
SET facilities =
'{ "restaurants": 5,
   "lounges": 2,
   "parking": true
}'::jsonb
WHERE airport_code = 'SVO';

-- Bookings
UPDATE bookings
SET payment_details =
'{ "method": "credit_card",
   "status": "completed"
}'::jsonb
WHERE book_ref = 'ABC123';

-- Boarding_passes
UPDATE boarding_passes
SET boarding_info =
'{ "boarding_start": "2023-10-01T10:00:00",
   "boarding_end": "2023-10-01T10:30:00"
}'::jsonb
WHERE ticket_no = '1234567890123' AND flight_id = 1;

-- Seats
UPDATE seats
SET seat_features =
'{ "power_outlet": true,
   "extra_legroom": false
}'::jsonb
WHERE aircraft_code = '320' AND seat_no = 'A1';

-- Проверяем данные

-- Flights
SELECT flight_id, flight_details
FROM flights
WHERE flight_id = 1;

-- Airports
SELECT airport_code, facilities
FROM airports
WHERE airport_code = 'SVO';

-- Bookings
SELECT book_ref, payment_details
FROM bookings
WHERE book_ref = 'ABC123';

-- Boarding_passes
SELECT ticket_no, flight_id, boarding_info
FROM boarding_passes
WHERE ticket_no = '1234567890123' AND flight_id = 1;

-- Seats
SELECT aircraft_code, seat_no, seat_features
FROM seats
WHERE aircraft_code = '320' AND seat_no = 'A1';