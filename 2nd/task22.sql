-- Показываем текущее значение параметра intervalstyle
SHOW intervalstyle;

-- Изменение параметра intervalstyle на 'postgres'
SET intervalstyle TO 'postgres';

-- Пример интервала с новым форматом
SELECT '1 year 2 months 3 days 4 hours 5 minutes 6 seconds'::interval;

-- Изменение параметра intervalstyle на 'sql_standard'
SET intervalstyle TO 'sql_standard';

-- Пример интервала с новым форматом
SELECT '1 year 2 months 3 days 4 hours 5 minutes 6 seconds'::interval;

-- Возвращаем intervalstyle к значению по умолчанию
SET intervalstyle TO DEFAULT;