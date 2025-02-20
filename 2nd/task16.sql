-- Изменение параметра datestyle на 'SQL, YMD'
SET datestyle TO 'SQL, YMD';

-- Проверка нового значения datestyle
SHOW datestyle;

-- Пример ввода и вывода даты с новым форматом
SELECT '2016-05-18'::date;
SELECT '18-05-2016'::date; -- Ошибка

-- Пример ввода и вывода timestamp с новым форматом
SELECT '2016-05-18 14:30:00'::timestamp;
SELECT '18-05-2016 14:30:00'::timestamp; -- Ошибка

-- Возвращаем datestyle к значению по умолчанию
SET datestyle TO DEFAULT;