CREATE OR REPLACE FUNCTION calculate_department_bonuses(p_boss_id INTEGER)
RETURNS DECIMAL(12,4) AS $$
DECLARE
    emp_record RECORD;
    total_bonus DECIMAL(12,4) := 0;
    emp_cursor CURSOR FOR
        WITH RECURSIVE dept_employees AS (
            SELECT emp_nbr FROM Org_chart WHERE emp_nbr = p_boss_id
            UNION ALL
            SELECT o.emp_nbr FROM Org_chart o
            JOIN dept_employees d ON o.boss_emp_nbr = d.emp_nbr
        )
        SELECT o.emp_nbr, o.salary, p.emp_name
        FROM Org_chart o
        JOIN Personnel p ON o.emp_nbr = p.emp_nbr
        WHERE o.emp_nbr IN (SELECT emp_nbr FROM dept_employees);
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN NOT FOUND;
        
        -- Рассчитываем бонус как 10% от зарплаты для каждого сотрудника
        total_bonus := total_bonus + (emp_record.salary * 0.1);
        
        -- Можно добавить логирование или другие операции
        RAISE NOTICE 'Бонус для % (код %): %', 
            emp_record.emp_name, 
            emp_record.emp_nbr, 
            (emp_record.salary * 0.1);
    END LOOP;
    CLOSE emp_cursor;
    
    RETURN total_bonus;
END;
$$ LANGUAGE plpgsql;

-- Пример вызова функции для расчета бонусов подразделения Вице-президента 2 (код 3)
SELECT calculate_department_bonuses(3);