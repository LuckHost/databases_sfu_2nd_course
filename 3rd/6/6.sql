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