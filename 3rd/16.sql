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