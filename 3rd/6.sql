-- Удаление таблиц, если они существуют
DROP TABLE IF EXISTS progress;
DROP TABLE IF EXISTS students;

-- Создание таблицы students с составным первичным ключом
CREATE TABLE students (
    record_book numeric(5) NOT NULL UNIQUE,
    name text NOT NULL,
    doc_ser numeric(4),
    doc_num numeric(6),
    PRIMARY KEY (doc_ser, doc_num)
);

-- Создание таблицы progress с измененным внешним ключом
CREATE TABLE progress (
    doc_ser numeric(4),
    doc_num numeric(6),
    subject text NOT NULL,
    acad_year text NOT NULL,
    term numeric(1) NOT NULL CHECK (term = 1 OR term = 2),
    mark numeric(1) NOT NULL CHECK (mark >= 3 AND mark <= 5) DEFAULT 5,
    FOREIGN KEY (doc_ser, doc_num)
        REFERENCES students (doc_ser, doc_num)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Вставка данных в таблицу students
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES
    (12300, 'Иванов Иван Иванович', 0402, 543281),
    (12301, 'Петров Петр Петрович', 0403, 543282),
    (12302, 'Сидоров Сидор Сидорович', 0404, 543283);

-- Вставка данных в таблицу progress
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark)
VALUES
    (0402, 543281, 'Математика', '2023/2024', 1, 5),
    (0403, 543282, 'Физика', '2023/2024', 1, 4),
    (0404, 543283, 'Химия', '2023/2024', 2, 3);

-- Попытка вставить строку с несуществующим внешним ключом (должна вызвать ошибку)
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark)
VALUES
    (0405, 543284, 'Биология', '2023/2024', 1, 5); -- Ошибка: нарушение внешнего ключа

-- Попытка вставить строку с дубликатом первичного ключа в students (должна вызвать ошибку)
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES
    (12303, 'Козлов Козел Козлович', 0402, 543281); -- Ошибка: нарушение уникальности первичного ключа

-- Проверка данных в таблицах
SELECT * FROM students;
SELECT * FROM progress;