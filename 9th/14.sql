-- Пример вызова функции для работника с кодом 6 (Программист C)
SELECT * FROM up_tree_traversal(6);

-- Пример вызова для другого работника (например, Оператор - код 8)
SELECT * FROM up_tree_traversal(8);

-- Вызов по имени работника с использованием подзапроса
SELECT * FROM up_tree_traversal(
    (SELECT emp_nbr FROM Personnel WHERE emp_name = 'Иванов Иван Петрович')
);


-- Пример вызова функции для работника с кодом 6
SELECT * FROM up_tree_traversal2(6) AS (emp int, boss int);

-- Вызов по имени работника
SELECT * FROM up_tree_traversal2(
    (SELECT emp_nbr FROM Personnel WHERE emp_name = 'Климов Андрей Иванович')
) AS (emp int, boss int);