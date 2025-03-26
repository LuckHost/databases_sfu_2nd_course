SELECT 
    dw.name_of_day, 
    COUNT(*) AS num_flights
FROM 
    routes,
    unnest(days_of_week) WITH ORDINALITY AS r(day_num, ordinality)
    JOIN unnest('{ "Пн.", "Вт.", "Ср.", "Чт.", "Пт.", "Сб.", "Вс."}'::text[]) 
         WITH ORDINALITY AS dw(name_of_day, ordinality)
    ON r.ordinality = dw.ordinality
WHERE 
    departure_city = 'Москва'
GROUP BY 
    dw.name_of_day, dw.ordinality
ORDER BY 
    dw.ordinality;

-- Альтернативный вариант с CASE выражением
SELECT 
    CASE unnest(days_of_week)
        WHEN 1 THEN 'Пн.'
        WHEN 2 THEN 'Вт.'
        WHEN 3 THEN 'Ср.'
        WHEN 4 THEN 'Чт.'
        WHEN 5 THEN 'Пт.'
        WHEN 6 THEN 'Сб.'
        WHEN 7 THEN 'Вс.'
    END AS name_of_day,
    COUNT(*) AS num_flights
FROM 
    routes
WHERE 
    departure_city = 'Москва'
GROUP BY 
    name_of_day
ORDER BY 
    MIN(unnest(days_of_week));