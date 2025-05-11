-- Создаем новую базу данных
CREATE DATABASE university_records;

-- Подключаемся к созданной базе
\c university_records

-- Создаем таблицу Студенты
CREATE TABLE students (
    student_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    passport_series VARCHAR(4) NOT NULL,
    passport_number VARCHAR(6) NOT NULL,
    CONSTRAINT passport_unique UNIQUE (passport_series, passport_number)
);

-- Создаем таблицу Успеваемость
CREATE TABLE academic_performance (
    record_id SERIAL PRIMARY KEY,
    student_id VARCHAR(10) REFERENCES students(student_id),
    subject VARCHAR(50) NOT NULL,
    academic_year VARCHAR(9) NOT NULL,
    semester INTEGER NOT NULL CHECK (semester IN (1, 2)),
    grade INTEGER NOT NULL CHECK (grade BETWEEN 2 AND 5)
);

-- Заполняем таблицы тестовыми данными
INSERT INTO students (student_id, full_name, passport_series, passport_number) VALUES
('55500', 'Иванов Иван Петрович', '0402', '645327'),
('55800', 'Климов Андрей Иванович', '0402', '673211'),
('55865', 'Новиков Николай Юрьевич', '0202', '554390');

INSERT INTO academic_performance (student_id, subject, academic_year, semester, grade) VALUES
('55500', 'Физика', '2013/2014', 1, 5),
('55500', 'Математика', '2013/2014', 1, 4),
('55800', 'Физика', '2013/2014', 1, 4),
('55800', 'Физика', '2013/2014', 2, 5);