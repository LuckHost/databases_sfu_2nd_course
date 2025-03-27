-- Удаляем старые таблицы, если они существуют
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS airports CASCADE;
DROP TABLE IF EXISTS tickets CASCADE;
DROP TABLE IF EXISTS ticket_flights CASCADE;
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS aircrafts CASCADE;
DROP TABLE IF EXISTS boarding_passes CASCADE;
DROP TABLE IF EXISTS seats CASCADE;

-- Создаем таблицы заново

-- Таблица Bookings (Бронирования)
CREATE TABLE bookings (
    book_ref varchar(6) PRIMARY KEY,
    book_date timestamptz NOT NULL,
    total_amount numeric(10, 2) NOT NULL
);

-- Таблица Airports (Аэропорты)
CREATE TABLE airports (
    airport_code varchar(3) PRIMARY KEY,
    airport_name text NOT NULL,
    city text NOT NULL,
    longitude numeric(9, 6) NOT NULL,
    latitude numeric(9, 6) NOT NULL,
    timezone text NOT NULL
);

-- Таблица Tickets (Билеты)
CREATE TABLE tickets (
    ticket_no varchar(13) PRIMARY KEY,
    book_ref varchar(6) NOT NULL REFERENCES bookings(book_ref),
    passenger_id varchar(20) NOT NULL,
    passenger_name text NOT NULL,
    contact_data jsonb
);

-- Таблица Ticket_flights (Перелеты)
CREATE TABLE ticket_flights (
    ticket_no varchar(13) NOT NULL REFERENCES tickets(ticket_no),
    flight_id integer NOT NULL REFERENCES flights(flight_id),
    fare_conditions varchar(10) NOT NULL,
    amount numeric(10, 2) NOT NULL,
    PRIMARY KEY (ticket_no, flight_id)
);

-- Таблица Flights (Рейсы)
CREATE TABLE flights (
    flight_id serial PRIMARY KEY,
    flight_no varchar(10) NOT NULL,
    scheduled_departure timestamptz NOT NULL,
    scheduled_arrival timestamptz NOT NULL,
    departure_airport varchar(3) NOT NULL REFERENCES airports(airport_code),
    arrival_airport varchar(3) NOT NULL REFERENCES airports(airport_code),
    status varchar(20) NOT NULL,
    aircraft_code varchar(3) NOT NULL REFERENCES aircrafts(aircraft_code),
    actual_departure timestamptz,
    actual_arrival timestamptz
);

-- Таблица Aircrafts (Самолеты)
CREATE TABLE aircrafts (
    aircraft_code varchar(3) PRIMARY KEY,
    model text NOT NULL,
    range integer NOT NULL
);

-- Таблица Boarding_passes (Посадочные талоны)
CREATE TABLE boarding_passes (
    ticket_no varchar(13) NOT NULL REFERENCES tickets(ticket_no),
    flight_id integer NOT NULL REFERENCES flights(flight_id),
    boarding_no integer NOT NULL,
    seat_no varchar(4) NOT NULL,
    PRIMARY KEY (ticket_no, flight_id)
);

-- Таблица Seats (Места)
CREATE TABLE seats (
    aircraft_code varchar(3) NOT NULL REFERENCES aircrafts(aircraft_code),
    seat_no varchar(4) NOT NULL,
    fare_conditions varchar(10) NOT NULL,
    PRIMARY KEY (aircraft_code, seat_no)
);

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

-- Bookings
INSERT INTO bookings (book_ref, book_date, total_amount)
VALUES ('ABC123', '2023-09-30T12:00:00+03:00', 500.00);

-- Airports
INSERT INTO airports (airport_code, airport_name, city, longitude, latitude, timezone)
VALUES ('SVO', 'Шереметьево', 'Москва', 37.414722, 55.972778, 'Europe/Moscow');

-- Flights
INSERT INTO flights (flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, status, aircraft_code)
VALUES ('SU100', '2023-10-01T09:00:00+03:00', '2023-10-01T15:00:00-04:00', 'SVO', 'JFK', 'Scheduled', '320');

-- Tickets
INSERT INTO tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data)
VALUES ('1234567890123', 'ABC123', 'PASS123', 'Иванов Иван Иванович', '{"email": "ivanov@example.com", "phone": "+79161234567"}');

-- Ticket_flights
INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount)
VALUES ('1234567890123', 1, 'Business', 500.00);

-- Boarding_passes
INSERT INTO boarding_passes (ticket_no, flight_id, boarding_no, seat_no)
VALUES ('1234567890123', 1, 1, 'A1');

-- Seats
INSERT INTO seats (aircraft_code, seat_no, fare_conditions)
VALUES ('320', 'A1', 'Business');

-- Обновляем JSONB-столбцы

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

-- Bookings
SELECT book_ref, payment_details
FROM bookings
WHERE book_ref = 'ABC123';

-- Airports
SELECT airport_code, facilities
FROM airports
WHERE airport_code = 'SVO';

-- Flights
SELECT flight_id, flight_details
FROM flights
WHERE flight_id = 1;

-- Boarding_passes
SELECT ticket_no, flight_id, boarding_info
FROM boarding_passes
WHERE ticket_no = '1234567890123' AND flight_id = 1;

-- Seats
SELECT aircraft_code, seat_no, seat_features
FROM seats
WHERE aircraft_code = '320' AND seat_no = 'A1';