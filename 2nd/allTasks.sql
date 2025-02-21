-- Удаление таблицы, если она существует
DROP TABLE IF EXISTS test_numeric;

-- Создание таблицы с типом numeric без указания точности и масштаба
CREATE TABLE test_numeric
(
    measurement numeric,
    description text
);

-- Вставка данных с разной точностью
INSERT INTO test_numeric
VALUES (1234567890.0987654321, 'Точность 20 знаков, масштаб 10 знаков');

INSERT INTO test_numeric
VALUES (1.5, 'Точность 2 знака, масштаб 1 знак');

INSERT INTO test_numeric
VALUES (0.12345678901234567890, 'Точность 21 знак, масштаб 20 знаков');

INSERT INTO test_numeric
VALUES (1234567890, 'Точность 10 знаков, масштаб 0 знаков (целое число)');

-- Выборка данных для проверки
SELECT * FROM test_numeric;





-- Сравнение двух очень маленьких чисел
SELECT '5e-324'::double precision > '4e-324'::double precision;

-- Проверка значений
SELECT '5e-324'::double precision;
SELECT '4e-324'::double precision;

-- Эксперименты с очень большими числами
SELECT '1.7976931348623157e+308'::double precision; -- Максимальное значение для double precision
SELECT '1.7976931348623157e+309'::double precision; -- Попытка выйти за пределы диапазона





-- Проверка специального значения NaN
SELECT 'NaN'::real > 'Inf'::real;

-- Проверка результата умножения нуля на бесконечность
SELECT 0.0 * 'Inf'::real;

-- Сравнение NaN с другими значениями
SELECT 'NaN'::real = 'NaN'::real;
SELECT 'NaN'::real > 10000::real;





-- Удаление таблицы, если она существует
DROP TABLE IF EXISTS test_serial;

-- Создание таблицы с типом serial и первичным ключом
CREATE TABLE test_serial
(
    id serial PRIMARY KEY,
    name text
);

-- Вставка данных
INSERT INTO test_serial (name) VALUES ('Вишневая');
INSERT INTO test_serial (id, name) VALUES (2, 'Прохладная'); -- Ошибка, если id=2 уже существует
INSERT INTO test_serial (name) VALUES ('Грушевая');
INSERT INTO test_serial (name) VALUES ('Зеленая');
DELETE FROM test_serial WHERE id = 4;
INSERT INTO test_serial (name) VALUES ('Луговая');

-- Выборка данных для проверки
SELECT * FROM test_serial;





-- Проверка минимального и максимального значений для типов даты/времени
SELECT '4713-01-01 BC'::date; -- Минимальная дата
SELECT '294276-12-31'::date;  -- Максимальная дата

-- Проверка минимального и максимального значений для типа timestamp
SELECT '4713-01-01 00:00:00 BC'::timestamp; -- Минимальное значение
SELECT '294276-12-31 23:59:59'::timestamp;  -- Максимальное значение




-- Показываем текущее значение параметра datestyle
SHOW datestyle;

-- Пример ввода даты в формате DMY (день-месяц-год)
SELECT '18-05-2016'::date;

-- Пример ввода даты в формате MDY (месяц-день-год) - вызовет ошибку
SELECT '05-18-2016'::date;

-- Пример ввода даты в формате YMD (год-месяц-день) - универсальный формат
SELECT '2016-05-18'::date;

-- Изменение параметра datestyle на MDY
SET datestyle TO 'MDY';

-- Повторяем запросы с новым значением datestyle
SELECT '18-05-2016'::date; -- Ошибка
SELECT '05-18-2016'::date; -- Успешно

-- Возвращаем datestyle к значению по умолчанию
SET datestyle TO DEFAULT;





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





-- Изменение параметра datestyle в конфигурационном файле
-- (этот шаг выполняется вручную в файле postgresql.conf)

-- Пример проверки нового значения datestyle после перезапуска сервера
SHOW datestyle;

-- Пример ввода даты в новом формате
SELECT '05-18-2016'::timestamp;

-- Пример использования current_timestamp
SELECT current_timestamp;

-- Пример ввода недопустимой даты
SELECT 'Feb 29, 2015'::date; -- Ошибка






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





-- Пример вычитания единицы из времени (ошибка)
SELECT ('20:34:35'::time - 1);

-- Пример вычитания единицы из даты
SELECT ('2016-09-16'::date - 1);

-- Исправление ошибки: вычитание интервала из времени
SELECT ('20:34:35'::time - '1 hour'::interval);





-- Пример использования функции date_trunc с типом timestamp
SELECT date_trunc('hour', '2023-10-05 14:42:35'::timestamp);

-- Пример использования функции date_trunc с типом interval
SELECT date_trunc('hour', '5 days 14 hours 42 minutes'::interval);




-- Пример использования функции extract с типом timestamp
SELECT extract(year FROM '2023-10-05 14:42:35'::timestamp);

-- Пример использования функции extract с типом interval
SELECT extract(day FROM '5 days 14 hours 42 minutes'::interval);





-- Создание таблицы test_bool
CREATE TABLE test_bool
(
    a boolean,
    b text
);

-- Вставка данных (правильные команды)
INSERT INTO test_bool VALUES (TRUE, 'yes');
INSERT INTO test_bool VALUES ('yes', true);
INSERT INTO test_bool VALUES ('1', 'true');
INSERT INTO test_bool VALUES ('t', 'true');
INSERT INTO test_bool VALUES (1::boolean, 'true');

-- Вставка данных (ошибочные команды)
INSERT INTO test_bool VALUES (yes, 'yes');        -- Ошибка: yes без кавычек
INSERT INTO test_bool VALUES ('yes', TRUE);       -- Ошибка: порядок аргументов
INSERT INTO test_bool VALUES (1, 'true');         -- Ошибка: 1 не является boolean
INSERT INTO test_bool VALUES ('t', truth);        -- Ошибка: truth без кавычек
INSERT INTO test_bool VALUES (true, true);        -- Ошибка: второй аргумент не текст
INSERT INTO test_bool VALUES (111::boolean, 'true'); -- Ошибка: 111 не является boolean

-- Выборка данных для проверки
SELECT * FROM test_bool;





-- Пример конкатенации массивов
SELECT array_cat(ARRAY[1, 2, 3], ARRAY[3, 5]);

-- Пример удаления элемента из массива
SELECT array_remove(ARRAY[1, 2, 3], 3);

-- Пример использования других функций для работы с массивами
SELECT array_length(ARRAY[1, 2, 3], 1);          -- Длина массива
SELECT array_position(ARRAY[1, 2, 3], 2);        -- Позиция элемента
SELECT array_replace(ARRAY[1, 2, 3], 2, 99);     -- Замена элемента




-- Обновление значения по ключу home_lib для конкретного пилота
UPDATE pilot_hobbies
SET hobbies = jsonb_set(
    hobbies,                 -- исходный JSONB-объект
    '{home_lib}',            -- путь к ключу (в фигурных скобках)
    '"Central Library"'::jsonb  -- новое значение (строка в JSON-формате)
)
WHERE pilot_name = 'Ivan';   -- условие выбора строки

-- Проверка результата
SELECT pilot_name, hobbies->'home_lib' AS home_lib 
FROM pilot_hobbies 
WHERE pilot_name = 'Ivan';





-- Добавление нового ключа в JSON-объект с помощью оператора ||
UPDATE pilot_hobbies
SET hobbies = hobbies || '{"new_key": "some_value"}'::jsonb  -- объединение JSONB-объектов
WHERE pilot_name = 'Petr';  -- условие выбора строки

-- Проверка результата
SELECT pilot_name, hobbies 
FROM pilot_hobbies 
WHERE pilot_name = 'Petr';