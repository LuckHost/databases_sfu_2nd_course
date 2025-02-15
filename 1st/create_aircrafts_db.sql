-- Создаем базу данных с именем "aircrafts_db"
CREATE DATABASE aircrafts_db;

-- Подключаемся к созданной базе данных
\c aircrafts_db;

-- Создаем таблицу "aircrafts"
CREATE TABLE aircrafts (
    aircraft_code CHAR(3) PRIMARY KEY,  -- Код самолета (IATA), первичный ключ
    model TEXT NOT NULL,               -- Модель самолета
    range INTEGER NOT NULL CHECK (range > 0)  -- Максимальная дальность полета, км
);

-- Вставляем тестовые данные в таблицу
INSERT INTO aircrafts (aircraft_code, model, range) VALUES
('SU9', 'Sukhoi SuperJet-100', 3000),
('773', 'Boeing 777-300', 11100),
('763', 'Boeing 767-300', 7900),
('733', 'Boeing 737-300', 4200),
('320', 'Airbus A320-200', 5700),
('321', 'Airbus A321-200', 5600),
('319', 'Airbus A319-100', 6700),
('CN1', 'Cessna 208 Caravan', 1200),
('CR2', 'Bombardier CRJ-200', 2700);

-- Проверяем, что данные успешно добавлены
SELECT * FROM aircrafts;