DROP TABLE IF EXISTS Personnel CASCADE;
CREATE TABLE Personnel
( emp_nbr INTEGER -- код работника
 DEFAULT 0 NOT NULL PRIMARY KEY,
 emp_name VARCHAR( 10 ) -- имя работника
 DEFAULT '{ {vacant} }' NOT NULL,
 address VARCHAR( 35 ) NOT NULL, -- адрес работника
 birth_date DATE NOT NULL -- день рождения работника
);
-- Произведем первоначальное заполнение таблицы.
INSERT INTO Personnel VALUES
( 0, 'вакансия', '', '2014-05-19' ),
( 1, 'Иван', 'ул. Любителей языка C', '1962-12-01' ),
( 2, 'Петр', 'ул. UNIX гуру', '1965-10-21' ),
( 3, 'Антон', 'ул. Ассемблерная', '1964-04-17' ),
( 4, 'Захар', 'ул. им. СУБД PostgreSQL', '1963-09-27' ),
( 5, 'Ирина', 'просп. Программистов', '1968-05-12' ),
( 6, 'Анна', 'пер. Перловый', '1969-03-20' ),
( 7, 'Андрей', 'пл. Баз данных', '1945-11-07' ),
( 8, 'Николай', 'наб. ОС Linux', '1944-12-01' );



-- -----------------------------------------------------------
-- Таблица "Организационная структура"
-- -----------------------------------------------------------
DROP TABLE IF EXISTS Org_chart CASCADE;
CREATE TABLE Org_chart
( job_title VARCHAR( 30 ) -- наименование должности
 NOT NULL PRIMARY KEY,
 emp_nbr INTEGER -- код работника
 DEFAULT 0 NOT NULL -- 0 означает вакантную должность
 REFERENCES Personnel( emp_nbr ) -- внешний ключ
 ON DELETE SET DEFAULT
 ON UPDATE CASCADE
 -- Это ограничение будет отключаться при выполнении
 -- одной из хранимых процедур, поэтому DEFERRABLE.
 DEFERRABLE,
 boss_emp_nbr INTEGER -- код начальника данного работника
 DEFAULT 0
 -- Поскольку null означает корень иерархии, то ограничение
 -- NOT NULL вводить не будем.
 REFERENCES Personnel( emp_nbr ) -- внешний ключ
 ON DELETE SET DEFAULT
 ON UPDATE CASCADE
 -- Это ограничение будет отключаться при выполнении
 -- одной из хранимых процедур, поэтому DEFERRABLE.
 DEFERRABLE,
 salary DECIMAL( 12, 4 ) -- зарплата работника, занимающего
 -- эту должность
 NOT NULL CHECK ( salary >= 0.00 ),
 -- Работник не может быть сам себе начальником,
 -- т. е. код работника не должен совпадать с кодом
 -- начальника);
 -- если должность не занята, то код работника и код
 -- начальника равны 0.
 CHECK ( ( boss_emp_nbr <> emp_nbr ) OR
 ( boss_emp_nbr = 0 AND emp_nbr = 0 )
 ),
 -- Без этого внешнего ключа возможна ситуация, когда
 -- удаляется запись, значение поля emp_nbr которой
 -- используется в качестве значения поля boss_emp_nbr
 -- в других записях. Другими словами, работник, которого
 -- нет в орг. структуре, является начальником других
 -- работников, присутствующих в орг. структуре).
 FOREIGN KEY ( boss_emp_nbr )
 REFERENCES Org_chart ( emp_nbr )
 ON DELETE SET DEFAULT
 ON UPDATE CASCADE
 DEFERRABLE,
 -- Пришлось добавить и это ограничение, иначе
 -- внешний ключ FOREIGN KEY ( boss_emp_nbr ) создать
 -- невозможно.
 UNIQUE ( emp_nbr )
);
-- Произведем первоначальное заполнение таблицы.
-- Обратите внимание, что у главы компании нет начальника,
-- поэтому значение NULL.
INSERT INTO Org_chart VALUES
( 'Президент', 1, NULL, 1000.00 ),
( 'Вице-президент 1', 2, 1, 900.00 ),
( 'Вице-президент 2', 3, 1, 800.00 ),
( 'Архитектор', 4, 3, 700.00 ),
( 'Ведущий программист', 5, 3, 600.00 ),
( 'Программист C', 6, 3, 500.00 ),
( 'Программист Perl', 7, 5, 450.00 ),
( 'Оператор', 8, 5, 400.00 );


-- -----------------------------------------------------------
-- Представление (VIEW) для реконструирования организационной
-- структуры.
-- -----------------------------------------------------------
DROP VIEW IF EXISTS Personnel_org_chart CASCADE;
CREATE VIEW Personnel_org_chart
( emp_nbr, emp, boss_emp_nbr, boss ) AS

 -- За основу принимается таблица Org_chart).
 -- ПРИМЕЧАНИЕ. LEFT OUTER JOIN необходим,
 -- т. к. у руководителя организации нет начальника
 -- и значение поля boss_emp_nbr у него NULL.
 SELECT O1.emp_nbr, E1.emp_name, O1.boss_emp_nbr, B1.emp_name
 FROM ( Org_chart AS O1 LEFT OUTER JOIN Personnel AS B1
 ON O1.boss_emp_nbr = B1.emp_nbr ), Personnel AS E1
 WHERE O1.emp_nbr = E1.emp_nbr;



-- -----------------------------------------------------------
-- Построение всех путей сверху дерева вниз
-- (только для четырех уровней иерархии)
-- -----------------------------------------------------------
DROP VIEW IF EXISTS Create_paths;
CREATE VIEW Create_paths ( level1, level2, level3, level4 ) AS
 SELECT O1.emp AS e1, O2.emp AS e2, O3.emp AS e3,
 O4.emp AS e4
 FROM Personnel_org_chart AS O1
 LEFT OUTER JOIN Personnel_org_chart AS O2
 ON O1.emp = O2.boss
 LEFT OUTER JOIN Personnel_org_chart AS O3
 ON O2.emp = O3.boss
 LEFT OUTER JOIN Personnel_org_chart AS O4
 ON O3.emp = O4.boss
 -- Если закомментировать условие WHERE, тогда будут
 -- построены цепочки, начинающиеся с каждого работника,
 -- а не только с главного руководителя.
 WHERE O1.emp = 'Иван';
