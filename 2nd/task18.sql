-- Пример вычитания одной даты из другой
SELECT ('2016-09-16'::date - '2016-09-01'::date) AS date_difference;

-- Пример вычитания временных меток
SELECT (current_timestamp - '2016-01-01'::timestamp) AS interval_difference;