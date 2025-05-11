-- Триггерная функция для проверки данных студента
CREATE OR REPLACE FUNCTION check_student_data()
RETURNS trigger AS $$
BEGIN
    -- Проверка формата номера зачетной книжки (5 цифр)
    IF NEW.student_id !~ '^[0-9]{5}$' THEN
        RAISE EXCEPTION 'Номер зачетной книжки должен содержать 5 цифр';
    END IF;
    
    -- Проверка формата паспорта (серия 4 цифры, номер 6 цифр)
    IF NEW.passport_series !~ '^[0-9]{4}$' OR 
       NEW.passport_number !~ '^[0-9]{6}$' THEN
        RAISE EXCEPTION 'Паспортные данные должны быть в формате: серия 4 цифры, номер 6 цифр';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера BEFORE INSERT OR UPDATE
DROP TRIGGER IF EXISTS check_student_trigger ON students;
CREATE TRIGGER check_student_trigger
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW EXECUTE FUNCTION check_student_data();