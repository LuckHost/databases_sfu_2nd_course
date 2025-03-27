-- Создаем временную копию таблицы seats (если нужно)
CREATE TEMPORARY TABLE seats_tmp AS SELECT * FROM seats WITH NO DATA;

-- Вставляем тестовые данные с учетом разных компоновок классов
INSERT INTO seats_tmp (aircraft_code, seat_no, fare_conditions)
SELECT 
    aircraft_code, 
    seat_row::text || letter, 
    fare_condition
FROM
    -- Компоновки салонов (добавляем max_letter_business для бизнес-класса)
    (VALUES 
        ('SU9', 3, 20, 'C', 'F'),  -- Бизнес: до 3 ряда, места A-C; Эконом: до 20 ряда, места A-F
        ('773', 5, 30, 'D', 'I'),
        ('763', 4, 25, 'C', 'H'),
        ('733', 3, 20, 'C', 'F'),
        ('320', 5, 25, 'D', 'F'),
        ('321', 4, 20, 'C', 'F'),
        ('319', 3, 20, 'C', 'F'),
        ('CN1', 0, 10, NULL, 'B'),  -- Только эконом-класс
        ('CR2', 2, 15, 'B', 'D')
    ) AS aircraft_info (
        aircraft_code, 
        max_seat_row_business,
        max_seat_row_economy, 
        max_letter_business,
        max_letter_economy
    )
CROSS JOIN
    -- Классы обслуживания
    (VALUES ('Business'), ('Economy')) AS fare_conditions (fare_condition)
CROSS JOIN
    -- Номера рядов (генерируем динамически)
    generate_series(1, 30) AS seat_rows (seat_row)
CROSS JOIN
    -- Буквенные обозначения мест
    (VALUES ('A'), ('B'), ('C'), ('D'), ('E'), ('F'), ('G'), ('H'), ('I')) AS letters (letter)
WHERE
    CASE 
        -- Для бизнес-класса
        WHEN fare_condition = 'Business' AND max_seat_row_business > 0 THEN
            seat_row <= max_seat_row_business AND 
            letter <= COALESCE(max_letter_business, max_letter_economy)
        -- Для эконом-класса
        WHEN fare_condition = 'Economy' THEN
            seat_row > COALESCE(max_seat_row_business, 0) AND 
            seat_row <= max_seat_row_economy AND 
            letter <= max_letter_economy
        ELSE FALSE
    END;



-- Проверяем распределение мест по классам для конкретного самолета
SELECT 
    fare_conditions,
    COUNT(*) AS seats_count,
    MIN(seat_no) AS first_seat,
    MAX(seat_no) AS last_seat
FROM 
    seats_tmp
WHERE 
    aircraft_code = 'SU9'
GROUP BY 
    fare_conditions
ORDER BY 
    fare_conditions;