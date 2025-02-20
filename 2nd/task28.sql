-- Пример использования функции extract с типом timestamp
SELECT extract(year FROM '2023-10-05 14:42:35'::timestamp);

-- Пример использования функции extract с типом interval
SELECT extract(day FROM '5 days 14 hours 42 minutes'::interval);