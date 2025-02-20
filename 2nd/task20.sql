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