-- Создание таблицы subjects
CREATE TABLE subjects (
    subject_id integer PRIMARY KEY,
    subject text UNIQUE
);

-- Вставка данных в таблицу subjects
INSERT INTO subjects (subject_id, subject)
VALUES
    (1, 'Математика'),
    (2, 'Физика'),
    (3, 'Химия');

-- Модификация таблицы progress
ALTER TABLE progress
ADD COLUMN subject_id integer;

-- Обновление данных в таблице progress
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