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