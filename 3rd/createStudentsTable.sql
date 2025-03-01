-- Удаляем таблицу, если она уже существует
DROP TABLE IF EXISTS students;

-- Создаем таблицу students
CREATE TABLE students (
    record_book NUMERIC(5) NOT NULL,  -- Уникальный номер зачетной книжки
    name TEXT NOT NULL,                      -- ФИО студента
    doc_ser NUMERIC(4),                -- Серия документа (4 символа, включая лидирующие нули)
    doc_num NUMERIC(6),             -- Номер документа (6 цифр)
    who_adds_row TEXT DEFAULT current_user, -- добавленный столбец
    added_at timestamp DEFAULT current_timestamp, -- Добавленный столбец для времени
    PRIMARY KEY (record_book)           -- Составной первичный ключ
);

-- Вставляем тестовые данные
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES 
    (12300, 'Иванов Иван Иванович', '0402', 543281),
    (12301, 'Петров Петр Петрович', '0403', 654321);
