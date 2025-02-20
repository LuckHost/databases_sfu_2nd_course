-- Добавление нового ключа в JSON-объект с помощью оператора ||
UPDATE pilot_hobbies
SET hobbies = hobbies || '{"new_key": "some_value"}'::jsonb  -- объединение JSONB-объектов
WHERE pilot_name = 'Petr';  -- условие выбора строки

-- Проверка результата
SELECT pilot_name, hobbies 
FROM pilot_hobbies 
WHERE pilot_name = 'Petr';