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