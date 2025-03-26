-- Удаление таблиц, если они существуют
DROP TABLE IF EXISTS progress;
DROP TABLE IF EXISTS students;

-- Создаем таблицу students
CREATE TABLE students (
    record_book NUMERIC(5) NOT NULL,  -- Уникальный номер зачетной книжки
    name TEXT NOT NULL,                      -- ФИО студента
    doc_ser NUMERIC(4),                -- Серия документа (4 символа, включая лидирующие нули)
    doc_num NUMERIC(6),             -- Номер документа (6 цифр)
    who_adds_row TEXT DEFAULT current_user, -- добавленный столбец
    added_at timestamp DEFAULT current_timestamp, -- Добавленный столбец для времени
    PRIMARY KEY (record_book)           -- Составной первичный ключ
);

-- Вставляем тестовые данные
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES 
    (12300, 'Иванов Иван Иванович', '0402', 543281),
    (12301, 'Петров Петр Петрович', '0403', 654321);


-- Удаление таблиц, если они существуют
DROP TABLE IF EXISTS progress;
DROP TABLE IF EXISTS students;


-- Удаляем таблицу, если она уже существует
DROP TABLE IF EXISTS progress;

-- Создаем таблицу progress
CREATE TABLE progress (
    record_book NUMERIC(5) NOT NULL,  -- № зачетной книжки
    subject TEXT NOT NULL,            -- Учебная дисциплина
    acad_year TEXT NOT NULL,          -- Учебный год
    term NUMERIC(1) NOT NULL CHECK (term IN (1, 2)),  -- Семестр (1 или 2)
    mark NUMERIC(1) DEFAULT 5 CHECK (mark >= 0 AND mark <= 5 AND mark != 0),  -- Оценка (от 3 до 5)
    PRIMARY KEY (record_book, subject, acad_year, term)  -- Составной первичный ключ
);


-- Добавляем новый атрибут test_form
ALTER TABLE progress
ADD COLUMN test_form TEXT NOT NULL CHECK (test_form IN ('экзамен', 'зачет'));

-- Добавляем ограничение уровня таблицы
ALTER TABLE progress
ADD CHECK (
    (test_form = 'экзамен' AND mark IN (3, 4, 5)) OR
    (test_form = 'зачет' AND mark IN (0, 1))
);

-- Проверяем ограничение
-- Вставляем корректные данные
INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12300, 'Физика', '2016/2017', 1, 4, 'экзамен');

INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12301, 'Математика', '2016/2017', 1, 1, 'зачет');

-- Вставляем некорректные данные (должно вызвать ошибку)
INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12302, 'Химия', '2016/2017', 1, 2, 'экзамен');  -- Ошибка: mark не соответствует экзамену

INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12303, 'Биология', '2016/2017', 1, 5, 'зачет');  -- Ошибка: mark не соответствует зачету


-- Модифицируем таблицу progress, чтобы проверить поведение DEFAULT
ALTER TABLE progress
ALTER COLUMN mark SET DEFAULT 6;  -- Устанавливаем некорректное значение по умолчанию

-- Пытаемся вставить строку без указания значения для mark
INSERT INTO progress (record_book, subject, acad_year, test_form, term)
VALUES (12300, 'Физика', '2016/2017', 'экзамен', 1);  -- Ошибка: значение по умолчанию 6 нарушает CHECK

-- Возвращаем корректное значение по умолчанию
ALTER TABLE progress
ALTER COLUMN mark SET DEFAULT 5;

-- Проверяем вставку с корректным значением по умолчанию
INSERT INTO progress (record_book, subject, acad_year, test_form, term)
VALUES (12303, 'Матанализ', '2016/2017', 'экзамен', 1);  -- Успешно: mark = 5


-- Удаление таблиц, если они существуют
DROP TABLE IF EXISTS progress;
DROP TABLE IF EXISTS students;

-- Создание таблицы students с составным первичным ключом
CREATE TABLE students (
    record_book numeric(5) NOT NULL UNIQUE,
    name text NOT NULL,
    doc_ser numeric(4),
    doc_num numeric(6),
    PRIMARY KEY (doc_ser, doc_num)
);

-- Создание таблицы progress с измененным внешним ключом
CREATE TABLE progress (
    doc_ser numeric(4),
    doc_num numeric(6),
    subject text NOT NULL,
    acad_year text NOT NULL,
    term numeric(1) NOT NULL CHECK (term = 1 OR term = 2),
    mark numeric(1) NOT NULL CHECK (mark >= 3 AND mark <= 5) DEFAULT 5,
    FOREIGN KEY (doc_ser, doc_num)
        REFERENCES students (doc_ser, doc_num)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Вставка данных в таблицу students
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES
    (12300, 'Иванов Иван Иванович', 0402, 543281),
    (12301, 'Петров Петр Петрович', 0403, 543282),
    (12302, 'Сидоров Сидор Сидорович', 0404, 543283);

-- Вставка данных в таблицу progress
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark)
VALUES
    (0402, 543281, 'Математика', '2023/2024', 1, 5),
    (0403, 543282, 'Физика', '2023/2024', 1, 4),
    (0404, 543283, 'Химия', '2023/2024', 2, 3);

-- Попытка вставить строку с несуществующим внешним ключом (должна вызвать ошибку)
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark)
VALUES
    (0405, 543284, 'Биология', '2023/2024', 1, 5); -- Ошибка: нарушение внешнего ключа

-- Попытка вставить строку с дубликатом первичного ключа в students (должна вызвать ошибку)
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES
    (12303, 'Козлов Козел Козлович', 0402, 543281); -- Ошибка: нарушение уникальности первичного ключа

-- Проверка данных в таблицах
SELECT * FROM students;
SELECT * FROM progress;



-- Создание таблицы subjects
CREATE TABLE subjects (
    subject_id integer PRIMARY KEY,
    subject text UNIQUE NOT NULL
);

-- Вставка данных в таблицу subjects
INSERT INTO subjects (subject_id, subject)
VALUES
    (1, 'Математика'),
    (2, 'Физика'),
    (3, 'Химия');

-- Добавление столбца subject_id в таблицу progress
ALTER TABLE progress
ADD COLUMN subject_id integer;

-- Обновление данных в таблице progress для связи с subjects
UPDATE progress
SET subject_id = subjects.subject_id
FROM subjects
WHERE progress.subject = subjects.subject;

-- Удаление старого столбца subject
ALTER TABLE progress
DROP COLUMN subject;

-- Добавление внешнего ключа на subject_id
ALTER TABLE progress
ADD FOREIGN KEY (subject_id) REFERENCES subjects(subject_id);

-- Вставка новых данных в таблицу progress с учетом новой структуры
INSERT INTO progress (doc_ser, doc_num, subject_id, acad_year, term, mark)
VALUES
    (0402, 543281, 1, '2023/2024', 1, 5),  -- Математика
    (0403, 543282, 2, '2023/2024', 1, 4),  -- Физика
    (0404, 543283, 3, '2023/2024', 2, 3);  -- Химия

-- Проверка данных в таблицах
SELECT * FROM students;
SELECT * FROM subjects;
SELECT * FROM progress;

-- Шаг 1: Удаление внешнего ключа
ALTER TABLE progress
DROP CONSTRAINT progress_doc_ser_doc_num_fkey;

-- Шаг 2: Изменение типа данных столбца doc_ser в таблице students
ALTER TABLE students
ALTER COLUMN doc_ser TYPE char(3)
USING doc_ser::character(3);

-- Шаг 3: Изменение типа данных столбца doc_ser в таблице progress
ALTER TABLE progress
ALTER COLUMN doc_ser TYPE char(3)
USING doc_ser::character(3);

-- Шаг 4: Восстановление внешнего ключа
ALTER TABLE progress
ADD FOREIGN KEY (doc_ser, doc_num)
REFERENCES students (doc_ser, doc_num)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Проверка данных
SELECT * FROM students;
SELECT * FROM progress;



DROP TABLE IF EXISTS airports CASCADE;

-- Создание таблиц
CREATE TABLE Airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name TEXT NOT NULL,
    city TEXT NOT NULL,
    longitude FLOAT NOT NULL,
    latitude FLOAT NOT NULL,
    timezone TEXT NOT NULL
);

CREATE TABLE Flights (
    flight_id SERIAL PRIMARY KEY,
    flight_no VARCHAR(10) NOT NULL,
    scheduled_departure TIMESTAMP NOT NULL,
    scheduled_arrival TIMESTAMP NOT NULL,
    departure_airport CHAR(3) REFERENCES Airports(airport_code),
    arrival_airport CHAR(3) REFERENCES Airports(airport_code),
    status VARCHAR(20) NOT NULL,
    aircraft_code VARCHAR(10),
    actual_departure TIMESTAMP,
    actual_arrival TIMESTAMP
);

-- Проверка ограничений до переименования
SELECT conname, conrelid::regclass, confrelid::regclass
FROM pg_constraint
WHERE conrelid = 'Flights'::regclass;

-- Переименование таблицы
ALTER TABLE Flights RENAME TO FlightsNew;

-- Проверка ограничений после переименования
SELECT conname, conrelid::regclass, confrelid::regclass
FROM pg_constraint
WHERE conrelid = 'FlightsNew'::regclass;


-- Удаляем представление, если оно существует
DROP VIEW IF EXISTS MoscowAirports;
DROP MATERIALIZED VIEW IF EXISTS MoscowAirports;

-- Удаляем таблицу, если она существует

DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS FlightsNew;
DROP TABLE IF EXISTS Airports;

-- Создаем таблицу Airports
CREATE TABLE Airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name TEXT NOT NULL,
    city TEXT NOT NULL,
    longitude FLOAT NOT NULL,
    latitude FLOAT NOT NULL,
    timezone TEXT NOT NULL
);

-- Вставляем тестовые данные
INSERT INTO Airports (airport_code, airport_name, city, longitude, latitude, timezone)
VALUES
    ('SVO', 'Sheremetyevo', 'Moscow', 37.414722, 55.972778, 'Europe/Moscow'),
    ('LED', 'Pulkovo', 'Saint Petersburg', 30.2625, 59.800278, 'Europe/Moscow'),
    ('JFK', 'John F. Kennedy', 'New York', -73.778889, 40.639722, 'America/New_York');

-- Создаем обновляемое представление MoscowAirports
CREATE VIEW MoscowAirports AS
SELECT airport_code, airport_name, city, longitude, latitude, timezone
FROM Airports
WHERE city = 'Moscow';

-- Проверяем данные в представлении
SELECT * FROM MoscowAirports;

-- Добавляем новый аэропорт через INSERT
INSERT INTO MoscowAirports (airport_code, airport_name, city, longitude, latitude, timezone)
VALUES ('DME', 'Domodedovo', 'Moscow', 37.906111, 55.408611, 'Europe/Moscow');

-- Проверяем данные в представлении после INSERT
SELECT * FROM MoscowAirports;

-- Обновляем данные через UPDATE
UPDATE MoscowAirports
SET airport_name = 'Sheremetyevo International'
WHERE airport_code = 'SVO';

-- Проверяем данные в представлении после UPDATE
SELECT * FROM MoscowAirports;

-- Удаляем данные через DELETE
DELETE FROM MoscowAirports
WHERE airport_code = 'DME';

-- Проверяем данные в представлении после DELETE
SELECT * FROM MoscowAirports;

-- Проверяем изменения в базовой таблице Airports
SELECT * FROM Airports;


-- Удаляем материализованное представление, если оно существует
DROP VIEW IF EXISTS MoscowAirports;
DROP MATERIALIZED VIEW IF EXISTS MoscowAirports;

-- Удаляем таблицу, если она существует
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS FlightsNew;
DROP TABLE IF EXISTS Airports;

-- Создаем таблицу Airports
CREATE TABLE Airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name TEXT NOT NULL,
    city TEXT NOT NULL,
    longitude FLOAT NOT NULL,
    latitude FLOAT NOT NULL,
    timezone TEXT NOT NULL
);

-- Вставляем тестовые данные
INSERT INTO Airports (airport_code, airport_name, city, longitude, latitude, timezone)
VALUES
    ('SVO', 'Sheremetyevo', 'Moscow', 37.414722, 55.972778, 'Europe/Moscow'),
    ('LED', 'Pulkovo', 'Saint Petersburg', 30.2625, 59.800278, 'Europe/Moscow'),
    ('JFK', 'John F. Kennedy', 'New York', -73.778889, 40.639722, 'America/New_York');

-- Создаем материализованное представление
CREATE MATERIALIZED VIEW MoscowAirports AS
SELECT airport_code, airport_name, city, longitude, latitude, timezone
FROM Airports
WHERE city = 'Moscow';

-- Проверяем данные в материализованном представлении
SELECT * FROM MoscowAirports;

-- Добавляем новый аэропорт в Москве
INSERT INTO Airports (airport_code, airport_name, city, longitude, latitude, timezone)
VALUES ('DME', 'Domodedovo', 'Moscow', 37.906111, 55.408611, 'Europe/Moscow');

-- Проверяем данные в материализованном представлении (данные не изменились)
SELECT * FROM MoscowAirports;

-- Обновляем материализованное представление
REFRESH MATERIALIZED VIEW MoscowAirports;

-- Проверяем данные в материализованном представлении после обновления
SELECT * FROM MoscowAirports;


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