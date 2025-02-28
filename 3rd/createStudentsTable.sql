-- Удаляем таблицу, если она уже существует
DROP TABLE IF EXISTS students;

-- Создаем таблицу students
CREATE TABLE students (
    record_book NUMERIC(5) NOT NULL UNIQUE,  -- Уникальный номер зачетной книжки
    name TEXT NOT NULL,                      -- ФИО студента
    doc_ser CHAR(4) NOT NULL,                -- Серия документа (4 символа, включая лидирующие нули)
    doc_num NUMERIC(6) NOT NULL,             -- Номер документа (6 цифр)
    PRIMARY KEY (doc_ser, doc_num)           -- Составной первичный ключ
);

-- Вставляем тестовые данные
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES 
    (12300, 'Иванов Иван Иванович', '0402', 543281),
    (12301, 'Петров Петр Петрович', '0403', 654321);
