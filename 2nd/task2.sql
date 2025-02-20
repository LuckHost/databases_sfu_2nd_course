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