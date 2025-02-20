-- Сравнение двух очень маленьких чисел
SELECT '5e-324'::double precision > '4e-324'::double precision;

-- Проверка значений
SELECT '5e-324'::double precision;
SELECT '4e-324'::double precision;

-- Эксперименты с очень большими числами
SELECT '1.7976931348623157e+308'::double precision; -- Максимальное значение для double precision
SELECT '1.7976931348623157e+309'::double precision; -- Попытка выйти за пределы диапазона