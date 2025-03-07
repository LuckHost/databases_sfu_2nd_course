-- Шаг 1: Удаление внешнего ключа
ALTER TABLE progress
DROP CONSTRAINT progress_doc_ser_doc_num_fkey;

-- Шаг 2: Изменение типа данных столбца doc_ser в таблице students
ALTER TABLE students
ALTER COLUMN doc_ser TYPE char(3)
USING doc_ser::character(3);

-- Шаг 3: Изменение типа данных столбца doc_ser в таблице progress
ALTER TABLE progress
ALTER COLUMN doc_ser TYPE char(3)
USING doc_ser::character(3);

-- Шаг 4: Восстановление внешнего ключа
ALTER TABLE progress
ADD FOREIGN KEY (doc_ser, doc_num)
REFERENCES students (doc_ser, doc_num)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Проверка данных
SELECT * FROM students;
SELECT * FROM progress;