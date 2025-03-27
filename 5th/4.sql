-- Создаем копию таблицы seats
CREATE TABLE seats_copy (LIKE seats INCLUDING CONSTRAINTS);

-- Копируем данные
INSERT INTO seats_copy SELECT * FROM seats;

-- Вставка с обработкой конфликта по составному ключу (перечисление столбцов)
INSERT INTO seats_copy (aircraft_code, seat_no, fare_conditions)
VALUES ('SU9', '1A', 'Business')
ON CONFLICT (aircraft_code, seat_no) 
DO UPDATE SET
    fare_conditions = EXCLUDED.fare_conditions,
    -- Можно добавить другие поля при необходимости
    seat_no = EXCLUDED.seat_no
RETURNING *;

-- Вставка с обработкой конфликта по имени ограничения
INSERT INTO seats_copy (aircraft_code, seat_no, fare_conditions)
VALUES ('SU9', '1A', 'Economy')
ON CONFLICT ON CONSTRAINT seats_copy_pkey  -- имя первичного ключа
DO UPDATE SET
    fare_conditions = EXCLUDED.fare_conditions
RETURNING *;