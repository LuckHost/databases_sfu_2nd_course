-- Удаляем таблицу, если она уже существует
DROP TABLE IF EXISTS students;

-- Создаем таблицу students
CREATE TABLE students (
    record_book NUMERIC(5) NOT NULL UNIQUE,  -- Уникальный номер зачетной книжки
    name TEXT NOT NULL CHECK (name <> ''),   -- Имя студента (не пустая строка)
    doc_ser CHAR(4) NOT NULL,               -- Серия документа (4 символа, включая лидирующие нули)
    doc_num NUMERIC(6) NOT NULL,            -- Номер документа (6 цифр)
    who_adds_row TEXT DEFAULT current_user,  -- Пользователь, добавивший запись
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Время добавления записи
    PRIMARY KEY (doc_ser, doc_num)          -- Составной первичный ключ
);

-- Комментарии к таблице и столбцам
COMMENT ON TABLE students IS 'Таблица для хранения данных о студентах';
COMMENT ON COLUMN students.record_book IS 'Уникальный номер зачетной книжки';
COMMENT ON COLUMN students.name IS 'ФИО студента';
COMMENT ON COLUMN students.doc_ser IS 'Серия документа, удостоверяющего личность';
COMMENT ON COLUMN students.doc_num IS 'Номер документа, удостоверяющего личность';
COMMENT ON COLUMN students.who_adds_row IS 'Пользователь, добавивший запись';
COMMENT ON COLUMN students.added_at IS 'Время добавления записи';

-- Вставляем тестовые данные
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES 
    (12345, 'Иванов Иван Иванович', '0402', 123456),
    (12346, 'Петров Петр Петрович', '0403', 654321),
    (12347, 'Сидоров Алексей Владимирович', '0404', 112233),
    (12348, 'Козлова Анна Сергеевна', '0405', 445566),
    (12349, 'Михайлов Дмитрий Андреевич', '0406', 778899),
    (12350, 'Новикова Екатерина Павловна', '0407', 990011),
    (12351, 'Федоров Артем Игоревич', '0408', 223344),
    (12352, 'Смирнова Ольга Дмитриевна', '0409', 556677),
    (12353, 'Кузнецов Владислав Александрович', '0410', 889900),
    (12354, 'Васильева Марина Викторовна', '0411', 334455);

-- Проверяем данные
SELECT * FROM students;