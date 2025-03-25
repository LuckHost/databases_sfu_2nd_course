-- Проверяем существование таблицы и удаляем если она есть
DROP TABLE IF EXISTS tickets;

-- Создаем таблицу Билеты
CREATE TABLE tickets (
    ticket_no VARCHAR(20) PRIMARY KEY,
    book_ref VARCHAR(10),
    passenger_id VARCHAR(20),
    passenger_name VARCHAR(100) NOT NULL,
    contact_data JSONB
);

-- Добавляем тестовые данные
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
('TK1010', 'BR109', 'PID110', 'Sam Taylor', '{"email": "sam@example.com", "phone": "+1234567899"}');