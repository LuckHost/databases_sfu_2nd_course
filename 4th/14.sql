SELECT 
    right(passenger_name, length(passenger_name) - strpos(passenger_name, ' ')) AS lastname,
    count(*) AS frequency
FROM 
    tickets
WHERE 
    passenger_name LIKE '% %'  -- Убедимся, что есть пробел (имя и фамилия)
GROUP BY 
    lastname
ORDER BY 
    frequency DESC;

-- С использованием функции substring
SELECT 
    substring(passenger_name from strpos(passenger_name, ' ') + 1) AS lastname,
    count(*) AS frequency
FROM 
    tickets
GROUP BY 
    lastname
ORDER BY 
    frequency DESC;

-- С разбиением по регулярному выражению
SELECT 
    (regexp_matches(passenger_name, '^.*\s(.*)$'))[1] AS lastname,
    count(*) AS frequency
FROM 
    tickets
GROUP BY 
    lastname
ORDER BY 
    frequency DESC;