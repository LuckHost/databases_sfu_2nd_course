-- Пример конкатенации массивов
SELECT array_cat(ARRAY[1, 2, 3], ARRAY[3, 5]);

-- Пример удаления элемента из массива
SELECT array_remove(ARRAY[1, 2, 3], 3);

-- Пример использования других функций для работы с массивами
SELECT array_length(ARRAY[1, 2, 3], 1);          -- Длина массива
SELECT array_position(ARRAY[1, 2, 3], 2);        -- Позиция элемента
SELECT array_replace(ARRAY[1, 2, 3], 2, 99);     -- Замена элемента