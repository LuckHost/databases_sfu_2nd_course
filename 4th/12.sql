SELECT 
    CASE day_num
        WHEN 1 THEN 'Пн.'
        WHEN 2 THEN 'Вт.'
        WHEN 3 THEN 'Ср.'
        WHEN 4 THEN 'Чт.'
        WHEN 5 THEN 'Пт.'
        WHEN 6 THEN 'Сб.'
        WHEN 7 THEN 'Вс.'
    END AS name_of_day,
    COUNT(*) AS num_flights
FROM (
    SELECT unnest(days_of_week) AS day_num
    FROM routes
    WHERE departure_city = 'Москва'
) AS days
GROUP BY 
    name_of_day, day_num
ORDER BY 
    day_num;
