CREATE OR REPLACE FUNCTION count_letters()
RETURNS TABLE(letter CHAR, count BIGINT) AS $$
BEGIN
    -- Создаем временную таблицу со всеми буквами алфавита
    CREATE TEMP TABLE alphabet (letter CHAR) ON COMMIT DROP;
    INSERT INTO alphabet 
    SELECT chr(generate_series(ascii('А'), ascii('Я'))) 
    UNION SELECT chr(generate_series(ascii('A'), ascii('Z')));
    
    -- Возвращаем соединение с подсчетом фамилий
    RETURN QUERY
    SELECT a.letter, COUNT(s.student_id)::BIGINT
    FROM alphabet a
    LEFT JOIN students s ON upper(substring(s.full_name FROM 1 FOR 1)) = a.letter
    GROUP BY a.letter
    ORDER BY a.letter;
END;
$$ LANGUAGE plpgsql;

-- Пример вызова функции
SELECT * FROM count_letters();