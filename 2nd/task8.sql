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
INSERT INTO test_serial (name) VALUES ('Грушевая');

INSERT INTO test_serial (name) VALUES ('Зеленая');
DELETE FROM test_serial WHERE id = 4;
INSERT INTO test_serial (name) VALUES ('Луговая');

-- Выборка данных для проверки
SELECT * FROM test_serial;