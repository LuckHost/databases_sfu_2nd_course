DROP TABLE IF EXISTS pilot_hobbies;

-- Создание таблицы pilot_hobbies
CREATE TABLE pilot_hobbies (
    pilot_name text PRIMARY KEY,
    hobbies jsonb
);

-- Вставка данных в таблицу pilot_hobbies
INSERT INTO pilot_hobbies (pilot_name, hobbies)
VALUES 
    ('Ivan', '{"trips": 3, "home_lib": "Main Library"}'),
    ('Petr', '{"trips": 2, "home_lib": "City Library"}'),
    ('Boris', '{"trips": 0, "home_lib": "Town Library"}'),
    ('Pavel', '{"trips": 5, "home_lib": "Central Library"}');

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