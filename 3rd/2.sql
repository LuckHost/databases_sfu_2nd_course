-- Добавляем новый атрибут test_form
ALTER TABLE progress
ADD COLUMN test_form TEXT NOT NULL CHECK (test_form IN ('экзамен', 'зачет'));

-- Добавляем ограничение уровня таблицы
ALTER TABLE progress
ADD CHECK (
    (test_form = 'экзамен' AND mark IN (3, 4, 5)) OR
    (test_form = 'зачет' AND mark IN (0, 1))
);

-- Проверяем ограничение
-- Вставляем корректные данные
INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12300, 'Физика', '2016/2017', 1, 4, 'экзамен');

INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12301, 'Математика', '2016/2017', 1, 1, 'зачет');

-- Вставляем некорректные данные (должно вызвать ошибку)
INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12302, 'Химия', '2016/2017', 1, 2, 'экзамен');  -- Ошибка: mark не соответствует экзамену

INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form)
VALUES (12303, 'Биология', '2016/2017', 1, 5, 'зачет');  -- Ошибка: mark не соответствует зачету