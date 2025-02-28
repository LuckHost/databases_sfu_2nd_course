-- Модифицируем тип данных для doc_ser
ALTER TABLE students
ALTER COLUMN doc_ser TYPE CHAR(4);

-- Проверяем вставку данных с лидирующими нулями
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (12302, 'Петров Петр Петрович', '0402', 123456);

-- Проверяем, что данные сохранились корректно
SELECT * FROM students WHERE doc_ser = '0402';