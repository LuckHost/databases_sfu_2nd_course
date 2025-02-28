-- Модифицируем таблицу students
ALTER TABLE students
DROP CONSTRAINT students_pkey;  -- Удаляем старый первичный ключ

ALTER TABLE students
ADD PRIMARY KEY (doc_ser, doc_num);  -- Добавляем новый составной первичный ключ

-- Модифицируем таблицу progress
ALTER TABLE progress
DROP CONSTRAINT progress_doc_ser_fkey;  -- Удаляем старый внешний ключ

ALTER TABLE progress
ADD FOREIGN KEY (doc_ser, doc_num)
REFERENCES students (doc_ser, doc_num)
ON DELETE CASCADE
ON UPDATE CASCADE;  -- Добавляем новый составной внешний ключ

-- Проверяем работу составных ключей
-- Вставляем данные в students
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (12300, 'Иванов Иван Иванович', 0402, 543281);

-- Вставляем данные в progress
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark)
VALUES (0402, 543281, 'Физика', '2016/2017', 1, 5);

-- Проверяем каскадное обновление
UPDATE students
SET doc_ser = 0403
WHERE doc_ser = 0402 AND doc_num = 543281;

-- Проверяем, что данные в progress обновились
SELECT * FROM progress WHERE doc_ser = 0403 AND doc_num = 543281;