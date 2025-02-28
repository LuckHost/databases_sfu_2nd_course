-- Удаляем таблицу, если она уже существует
DROP TABLE IF EXISTS progress;

-- Создаем таблицу progress
CREATE TABLE progress (
    record_book NUMERIC(5) NOT NULL,  -- № зачетной книжки
    subject TEXT NOT NULL,            -- Учебная дисциплина
    acad_year TEXT NOT NULL,          -- Учебный год
    term NUMERIC(1) NOT NULL CHECK (term IN (1, 2)),  -- Семестр (1 или 2)
    mark NUMERIC(1) DEFAULT 5 CHECK (mark >= 0 AND mark <= 5 AND mark != 0),  -- Оценка (от 3 до 5)
    PRIMARY KEY (record_book, subject, acad_year, term)  -- Составной первичный ключ
);
