-- Создаем таблицу subjects
CREATE TABLE subjects (
    subject_id SERIAL PRIMARY KEY,
    subject TEXT NOT NULL UNIQUE
);

-- Вставляем данные в subjects
INSERT INTO subjects (subject)
VALUES ('Физика'), ('Математика'), ('Химия');

-- Модифицируем таблицу progress
ALTER TABLE progress
ADD COLUMN subject_id INT;

-- Обновляем существующие данные в progress
UPDATE progress
SET subject_id = subjects.subject_id
FROM subjects
WHERE progress.subject = subjects.subject;

-- Удаляем старый столбец subject
ALTER TABLE progress
DROP COLUMN subject;

-- Добавляем внешний ключ на subjects
ALTER TABLE progress
ADD FOREIGN KEY (subject_id) REFERENCES subjects (subject_id);

-- Проверяем вставку новых данных
INSERT INTO progress (doc_ser, doc_num, subject_id, acad_year, term, mark)
VALUES (0403, 543281, 1, '2016/2017', 1, 5);  -- subject_id = 1 соответствует 'Физика'