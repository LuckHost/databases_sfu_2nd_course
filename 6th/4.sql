-- Для примера возьмем таблицу tickets и создадим индекс по двум столбцам
CREATE INDEX idx_tickets_special ON tickets 
(book_ref DESC NULLS FIRST, passenger_name ASC NULLS LAST);

-- Просмотр структуры таблицы с индексами
\d tickets

-- Просмотр детальной информации об индексе
\di+ idx_tickets_special

-- 1. Запрос с условием по обоим столбцам (оптимальный случай)
EXPLAIN ANALYZE
SELECT * FROM tickets 
WHERE book_ref = 'ABC123' AND passenger_name = 'IVAN IVANOV';

-- 2. Запрос только по первому столбцу (book_ref)
EXPLAIN ANALYZE
SELECT * FROM tickets 
WHERE book_ref = 'ABC123' 
ORDER BY book_ref DESC;

-- 3. Запрос с сортировкой, соответствующей индексу
EXPLAIN ANALYZE
SELECT * FROM tickets 
ORDER BY book_ref DESC NULLS FIRST, passenger_name ASC NULLS LAST;

-- 1. Запрос только по второму столбцу (passenger_name)
EXPLAIN ANALYZE
SELECT * FROM tickets 
WHERE passenger_name = 'IVAN IVANOV';

-- 2. Запрос с обратной сортировкой
EXPLAIN ANALYZE
SELECT * FROM tickets 
ORDER BY book_ref ASC, passenger_name DESC;

-- 3. Запрос с другим условием по NULL-значениям
EXPLAIN ANALYZE
SELECT * FROM tickets 
WHERE book_ref IS NULL 
ORDER BY book_ref ASC NULLS LAST;

-- 1. Запрос только по второму столбцу (passenger_name)
EXPLAIN ANALYZE
SELECT * FROM tickets 
WHERE passenger_name = 'IVAN IVANOV';

-- 2. Запрос с обратной сортировкой
EXPLAIN ANALYZE
SELECT * FROM tickets 
ORDER BY book_ref ASC, passenger_name DESC;

-- 3. Запрос с другим условием по NULL-значениям
EXPLAIN ANALYZE
SELECT * FROM tickets 
WHERE book_ref IS NULL 
ORDER BY book_ref ASC NULLS LAST;