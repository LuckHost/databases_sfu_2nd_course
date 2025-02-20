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