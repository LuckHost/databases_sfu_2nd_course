-- Индекс для поиска рейсов по дате без времени
CREATE INDEX idx_flights_departure_date ON flights 
(date(scheduled_departure));

-- Запрос, использующий индекс
EXPLAIN ANALYZE
SELECT * FROM flights 
WHERE date(scheduled_departure) = '2023-12-01';