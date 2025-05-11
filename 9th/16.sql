-- Добавим новые записи для тестирования
INSERT INTO Personnel (emp_nbr, emp_name) VALUES 
(9, 'Старший программист'),
(10, 'Младший программист'),
(11, 'Стажер');

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