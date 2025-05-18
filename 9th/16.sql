-- Добавляем новых сотрудников в таблицу Personnel (сначала!)
INSERT INTO Personnel (emp_nbr, emp_name, address, birth_date) VALUES 
(9, 'Старший', 'ул. Программистов', '1980-01-01'),  -- Сократил имя до 10 символов
(10, 'Младший', 'ул. Программистов', '1990-01-01'), -- Сократил имя до 10 символов
(11, 'Стажер', 'ул. Программистов', '1995-01-01');  -- Уложился в 10 символов

-- Теперь добавляем должности в Org_chart
INSERT INTO Org_chart (job_title, emp_nbr, boss_emp_nbr, salary) VALUES
('Старший программист', 9, 5, 550.00),
('Младший программист', 10, 9, 450.00),
('Стажер', 11, 10, 350.00);

-- Удаляем "Ведущего программиста" (код 5) и продвигаем подчиненных
SELECT * FROM delete_and_promote_subtree(5);

-- Альтернативный вызов по имени
SELECT * FROM delete_and_promote_subtree(
    (SELECT emp_nbr FROM Personnel WHERE emp_name = 'Ведущий программист')
);

-- Просмотр измененной структуры через представления
SELECT * FROM Personnel_org_chart;
SELECT * FROM Create_paths;