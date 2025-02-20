-- Изменение параметра datestyle на 'Postgres, DMY'
SET datestyle TO 'Postgres, DMY';

-- Проверка нового значения datestyle
SHOW datestyle;

-- Пример ввода и вывода даты с новым форматом
SELECT '18-05-2016'::date;
SELECT '2016-05-18'::date;

-- Пример ввода и вывода timestamp с новым форматом
SELECT '18-05-2016 14:30:00'::timestamp;
SELECT '2016-05-18 14:30:00'::timestamp;

-- Возвращаем datestyle к значению по умолчанию
SET datestyle TO DEFAULT;