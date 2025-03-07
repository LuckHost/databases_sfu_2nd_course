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