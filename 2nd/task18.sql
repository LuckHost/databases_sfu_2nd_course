-- Пример ввода недопустимой даты (29 февраля в невисокосном году)
SELECT 'Feb 29, 2015'::date; -- Ошибка

-- Пример вычитания одной даты из другой
SELECT ('2016-09-16'::date - '2016-09-01'::date) AS date_difference;

-- Пример вычитания временных меток
SELECT (current_timestamp - '2016-01-01'::timestamp) AS interval_difference;

-- Пример добавления интервала к временной метке
SELECT (current_timestamp + '1 mon'::interval) AS new_date;

-- Пример добавления интервала без псевдонима
SELECT (current_timestamp + '1 mon'::interval);