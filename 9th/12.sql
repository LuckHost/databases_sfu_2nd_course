-- 1. Представление "Персонал с должностями" (Personnel_org_chart)
CREATE OR REPLACE VIEW Personnel_org_chart AS
SELECT 
    p.emp_nbr,
    p.emp_name,
    o.job_title,
    o.salary,
    o.boss_emp_nbr,
    b.emp_name AS boss_name,
    b.job_title AS boss_job_title
FROM 
    Personnel p
JOIN 
    Org_chart o ON p.emp_nbr = o.emp_nbr
LEFT JOIN 
    (SELECT p.emp_nbr, p.emp_name, o.job_title 
     FROM Personnel p JOIN Org_chart o ON p.emp_nbr = o.emp_nbr) b 
    ON o.boss_emp_nbr = b.emp_nbr;

-- 2. Представление "Иерархия подразделений" (Create_paths)
CREATE OR REPLACE VIEW Create_paths AS
WITH RECURSIVE org_hierarchy AS (
    SELECT 
        emp_nbr, 
        boss_emp_nbr, 
        job_title, 
        1 AS level,
        job_title AS path
    FROM Org_chart
    WHERE boss_emp_nbr IS NULL
    
    UNION ALL
    
    SELECT 
        o.emp_nbr,
        o.boss_emp_nbr,
        o.job_title,
        h.level + 1,
        h.path || ' -> ' || o.job_title
    FROM Org_chart o
    JOIN org_hierarchy h ON o.boss_emp_nbr = h.emp_nbr
)
SELECT 
    emp_nbr,
    boss_emp_nbr,
    job_title,
    level,
    path
FROM org_hierarchy
ORDER BY level, emp_nbr;