-- Модифицируем таблицу progress, чтобы проверить поведение DEFAULT
ALTER TABLE progress
ALTER COLUMN mark SET DEFAULT 6;  -- Устанавливаем некорректное значение по умолчанию

-- Пытаемся вставить строку без указания значения для mark
INSERT INTO progress (record_book, subject, acad_year, test_form, term)
VALUES (12300, 'Физика', '2016/2017', 'экзамен', 1);  -- Ошибка: значение по умолчанию 6 нарушает CHECK

-- Возвращаем корректное значение по умолчанию
ALTER TABLE progress
ALTER COLUMN mark SET DEFAULT 5;

-- Проверяем вставку с корректным значением по умолчанию
INSERT INTO progress (record_book, subject, acad_year, test_form, term)
VALUES (12303, 'Матанализ', '2016/2017', 'экзамен', 1);  -- Успешно: mark = 5