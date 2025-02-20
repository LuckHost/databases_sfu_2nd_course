-- Проверка специального значения NaN
SELECT 'NaN'::real > 'Inf'::real;

-- Проверка результата умножения нуля на бесконечность
SELECT 0.0 * 'Inf'::real;

-- Сравнение NaN с другими значениями
SELECT 'NaN'::real = 'NaN'::real;
SELECT 'NaN'::real > 10000::real;