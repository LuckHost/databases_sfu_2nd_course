-- Пример использования функции date_trunc с типом timestamp
SELECT date_trunc('hour', '2023-10-05 14:42:35'::timestamp);

-- Пример использования функции date_trunc с типом interval
SELECT date_trunc('hour', '5 days 14 hours 42 minutes'::interval);