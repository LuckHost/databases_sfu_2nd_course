-- Создание таблицы subjects
CREATE TABLE subjects (
    subject_id integer PRIMARY KEY,
    subject text UNIQUE NOT NULL
);

-- Вставка данных в таблицу subjects
INSERT INTO subjects (subject_id, subject)
VALUES
    (1, 'Математика'),
    (2, 'Физика'),
    (3, 'Химия');

-- Добавление столбца subject_id в таблицу progress
ALTER TABLE progress
ADD COLUMN subject_id integer;

-- Обновление данных в таблице progress для связи с subjects
UPDATE progress
SET subject_id = subjects.subject_id
FROM subjects
WHERE progress.subject = subjects.subject;

-- Удаление старого столбца subject
ALTER TABLE progress
DROP COLUMN subject;

-- Добавление внешнего ключа на subject_id
ALTER TABLE progress
ADD FOREIGN KEY (subject_id) REFERENCES subjects(subject_id);

-- Вставка новых данных в таблицу progress с учетом новой структуры
INSERT INTO progress (doc_ser, doc_num, subject_id, acad_year, term, mark)
VALUES
    (0402, 543281, 1, '2023/2024', 1, 5),  -- Математика
    (0403, 543282, 2, '2023/2024', 1, 4),  -- Физика
    (0404, 543283, 3, '2023/2024', 2, 3);  -- Химия

-- Проверка данных в таблицах
SELECT * FROM students;
SELECT * FROM subjects;
SELECT * FROM progress;