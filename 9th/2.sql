-- Создаем временную функцию для примера
CREATE OR REPLACE FUNCTION temp_example() 
RETURNS INTEGER AS $$
BEGIN
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

-- Удаляем функцию
DROP FUNCTION IF EXISTS temp_example();