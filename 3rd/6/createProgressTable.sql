-- Удаляем таблицу, если она уже существует
DROP TABLE IF EXISTS progress;

-- Создаем таблицу progress
CREATE TABLE progress (
    doc_ser CHAR(4) NOT NULL,                -- Серия документа студента (внешний ключ)
    doc_num NUMERIC(6) NOT NULL,             -- Номер документа студента (внешний ключ)
    subject TEXT NOT NULL,                   -- Название учебной дисциплины
    acad_year TEXT NOT NULL,                 -- Учебный год (например, '2023/2024')
    term NUMERIC(1) NOT NULL CHECK (term IN (1, 2)),  -- Семестр (1 или 2)
    mark NUMERIC(1) DEFAULT 5 CHECK (mark >= 3 AND mark <= 5),  -- Оценка (от 3 до 5)
    FOREIGN KEY (doc_ser, doc_num) REFERENCES students (doc_ser, doc_num)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

