-- Удаляем таблицу, если она уже существует
DROP TABLE IF EXISTS progress;

-- Создаем таблицу progress
CREATE TABLE progress (
    id SERIAL PRIMARY KEY,  -- Уникальный идентификатор записи
    doc_ser CHAR(4) NOT NULL,  -- Серия документа студента (внешний ключ)
    doc_num NUMERIC(6) NOT NULL,  -- Номер документа студента (внешний ключ)
    subject TEXT NOT NULL,  -- Название учебной дисциплины
    acad_year TEXT NOT NULL,  -- Учебный год (например, '2023/2024')
    term NUMERIC(1) NOT NULL CHECK (term IN (1, 2)),  -- Семестр (1 или 2)
    mark NUMERIC(1) NOT NULL CHECK (mark >= 3 AND mark <= 5),  -- Оценка (от 3 до 5)
    FOREIGN KEY (doc_ser, doc_num) REFERENCES students (doc_ser, doc_num)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Комментарии к таблице и столбцам
COMMENT ON TABLE progress IS 'Таблица для хранения данных об успеваемости студентов';
COMMENT ON COLUMN progress.id IS 'Уникальный идентификатор записи';
COMMENT ON COLUMN progress.doc_ser IS 'Серия документа студента (внешний ключ)';
COMMENT ON COLUMN progress.doc_num IS 'Номер документа студента (внешний ключ)';
COMMENT ON COLUMN progress.subject IS 'Название учебной дисциплины';
COMMENT ON COLUMN progress.acad_year IS 'Учебный год';
COMMENT ON COLUMN progress.term IS 'Семестр (1 или 2)';
COMMENT ON COLUMN progress.mark IS 'Оценка (от 3 до 5)';
COMMENT ON COLUMN progress.test_form IS 'Форма проверки знаний (экзамен или зачет)';

-- Вставляем тестовые данные
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark, test_form)
VALUES 
    ('0402', 123456, 'Математика', '2023/2024', 1, 5, 'экзамен'),
    ('0403', 654321, 'Физика', '2023/2024', 1, 4, 'экзамен'),
    ('0404', 112233, 'Химия', '2023/2024', 1, 3, 'зачет'),
    ('0405', 445566, 'Информатика', '2023/2024', 2, 5, 'экзамен'),
    ('0406', 778899, 'История', '2023/2024', 2, 4, 'зачет');

-- Проверяем данные
SELECT * FROM progress;