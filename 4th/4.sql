-- 1. Создание таблицы tickets (если не существует) и наполнение тестовыми данными
DROP TABLE IF EXISTS tickets;

CREATE TABLE tickets (
    ticket_no VARCHAR(20) PRIMARY KEY,
    book_ref VARCHAR(10),
    passenger_id VARCHAR(20),
    passenger_name VARCHAR(100) NOT NULL,
    contact_data JSONB
);

INSERT INTO tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data) VALUES
('TK1001', 'BR100', 'PID101', 'Ivan Petrov', '{"email": "ivan@example.com", "phone": "+1234567890"}'),
('TK1002', 'BR101', 'PID102', 'Anna Smirn', '{"email": "anna@example.com", "phone": "+1234567891"}'),
('TK1003', 'BR102', 'PID103', 'Oleg Sidor', '{"email": "oleg@example.com", "phone": "+1234567892"}'),
('TK1004', 'BR103', 'PID104', 'Eva Brown', '{"email": "eva@example.com", "phone": "+1234567893"}'),
('TK1005', 'BR104', 'PID105', 'Max Power', '{"email": "max@example.com", "phone": "+1234567894"}'),
('TK1006', 'BR105', 'PID106', 'Li Zhao', '{"email": "li@example.com", "phone": "+1234567895"}'),
('TK1007', 'BR106', 'PID107', 'Al Exandrov', '{"email": "al@example.com", "phone": "+1234567896"}'),
('TK1008', 'BR107', 'PID108', 'Eva Green', '{"email": "eva.g@example.com", "phone": "+1234567897"}'),
('TK1009', 'BR108', 'PID109', 'Bob Smith', '{"email": "bob@example.com", "phone": "+1234567898"}'),
('TK1010', 'BR109', 'PID110', 'Sam Taylor', '{"email": "sam@example.com", "phone": "+1234567899"}'),
('TK1011', 'BR110', 'PID111', 'Alex NULL', NULL), -- Для демонстрации IS NULL
('TK1012', 'BR111', 'PID112', 'John Doe', '{"email": "john@example.com"}'); -- Нет поля phone

-- 2. Примеры использования различных предикатов сравнения

-- IN: Выбор билетов с определенными номерами
SELECT ticket_no, passenger_name 
FROM tickets 
WHERE ticket_no IN ('TK1001', 'TK1003', 'TK1005')
ORDER BY ticket_no;

-- NOT IN: Билеты, кроме указанных
SELECT ticket_no, passenger_name 
FROM tickets 
WHERE ticket_no NOT IN ('TK1001', 'TK1003', 'TK1005')
ORDER BY ticket_no;

-- IS NULL: Пассажиры без контактных данных
SELECT passenger_name 
FROM tickets 
WHERE contact_data IS NULL;

-- IS NOT NULL: Пассажиры с указанными контактными данными
SELECT passenger_name 
FROM tickets 
WHERE contact_data IS NOT NULL;

-- IS DISTINCT FROM: Сравнение с учетом NULL
SELECT passenger_name, contact_data 
FROM tickets 
WHERE contact_data->>'phone' IS DISTINCT FROM '+1234567890';

-- ANY: Билеты с номерами, большими чем любой из указанных
SELECT ticket_no, passenger_name 
FROM tickets 
WHERE ticket_no > ANY (ARRAY['TK1005', 'TK1007', 'TK1003'])
ORDER BY ticket_no;

-- ALL: Билеты с номерами, большими чем все указанные
SELECT ticket_no, passenger_name 
FROM tickets 
WHERE ticket_no > ALL (ARRAY['TK1005', 'TK1007', 'TK1003'])
ORDER BY ticket_no;

-- EXISTS: Подзапрос для проверки существования
SELECT t.passenger_name 
FROM tickets t
WHERE EXISTS (
    SELECT 1 FROM tickets 
    WHERE passenger_name LIKE 'Eva%' 
    AND ticket_no = t.ticket_no
);

-- LIKE: Поиск по шаблону (регистрозависимый)
SELECT passenger_name 
FROM tickets 
WHERE passenger_name LIKE 'A%'; -- Имена, начинающиеся на 'A'

-- ILIKE: Поиск по шаблону (регистронезависимый)
SELECT passenger_name 
FROM tickets 
WHERE passenger_name ILIKE 'a%'; -- Имена, начинающиеся на 'a' или 'A'

-- BETWEEN: Билеты в диапазоне номеров
SELECT ticket_no, passenger_name 
FROM tickets 
WHERE ticket_no BETWEEN 'TK1003' AND 'TK1007'
ORDER BY ticket_no;

-- OVERLAPS: Пример с датами (добавим временные данные для демонстрации)
ALTER TABLE tickets ADD COLUMN booking_period TSRANGE;

UPDATE tickets SET booking_period = 
    CASE ticket_no
        WHEN 'TK1001' THEN '[2023-01-01, 2023-01-10]'::TSRANGE
        WHEN 'TK1002' THEN '[2023-01-05, 2023-01-15]'::TSRANGE
        WHEN 'TK1003' THEN '[2023-01-20, 2023-01-25]'::TSRANGE
        WHEN 'TK1004' THEN '[2023-01-08, 2023-01-18]'::TSRANGE
        ELSE NULL
    END;

-- Демонстрация OVERLAPS для билетов, пересекающихся с указанным периодом
SELECT ticket_no, passenger_name, booking_period 
FROM tickets 
WHERE booking_period && '[2023-01-12, 2023-01-20]'::TSRANGE;