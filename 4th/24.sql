-- 1. Примеры с предикатом ANY

-- Эквивалент IN с использованием ANY
-- Найти аэропорты в определенных часовых поясах (эквивалент IN)
SELECT * FROM airports 
WHERE timezone = ANY(ARRAY['Asia/Novokuznetsk', 'Asia/Krasnoyarsk']);

-- Альтернативный синтаксис с подзапросом
SELECT * FROM airports
WHERE timezone = ANY(
  SELECT unnest(ARRAY['Asia/Novokuznetsk', 'Asia/Krasnoyarsk'])
);

-- Сравнение с агрегированными значениями
-- Найти рейсы, дальность которых больше хотя бы одного Боинга
SELECT f.flight_no, r.departure_city, r.arrival_city
FROM flights f
JOIN routes r ON f.flight_no = r.flight_no
WHERE f.aircraft_code = ANY(
  SELECT aircraft_code 
  FROM aircrafts 
  WHERE range > (SELECT MIN(range) FROM aircrafts WHERE model LIKE 'Boeing%')
);

-- Примеры с предикатом ALL

-- Эквивалент NOT IN с использованием ALL
-- Найти аэропорты не в указанных часовых поясах (эквивалент NOT IN)
SELECT * FROM airports
WHERE timezone <> ALL(ARRAY['Europe/Moscow', 'Europe/London']);

-- Альтернативный вариант
SELECT * FROM airports
WHERE NOT timezone = ANY(ARRAY['Europe/Moscow', 'Europe/London']);

-- Сравнение со всеми значениями
-- Найти самолеты, дальность которых больше всех Боингов
SELECT model, range
FROM aircrafts
WHERE range > ALL(
  SELECT range 
  FROM aircrafts 
  WHERE model LIKE 'Boeing%'
);

-- Комбинированные примеры

-- ANY с операторами сравнения
-- Найти рейсы, выполняемые самолетами с дальностью больше 5000 км
SELECT flight_no, departure_airport, arrival_airport
FROM flights
WHERE aircraft_code = ANY(
  SELECT aircraft_code
  FROM aircrafts
  WHERE range > 5000
);

-- ALL с операторами сравнения
-- Найти города, все аэропорты которых имеют longitude > 30
SELECT city
FROM airports
GROUP BY city
HAVING MIN(longitude) > 30;
-- Эквивалент с ALL:
SELECT DISTINCT city
FROM airports a1
WHERE longitude > ALL(
  SELECT 30
  WHERE NOT EXISTS (
    SELECT 1 FROM airports a2 
    WHERE a2.city = a1.city AND a2.longitude <= 30
  )
);

-- Практический пример с маршрутами

-- Модификация запроса из задания с использованием ANY
-- Количество маршрутов из самых восточных аэропортов (longitude > 150)
SELECT departure_city, count(*) 
FROM routes
GROUP BY departure_city
HAVING departure_city = ANY(
  SELECT city
  FROM airports
  WHERE longitude > 150
)
ORDER BY count DESC;

-- Альтернатива с JOIN (часто более эффективная)
SELECT r.departure_city, count(*) 
FROM routes r
JOIN airports a ON r.departure_city = a.city
WHERE a.longitude > 150
GROUP BY r.departure_city
ORDER BY count DESC;

-- Ключевые отличия ANY и ALL:

-- **ANY** - условие истинно, если выполняется для хотя бы одного элемента
-- **ALL** - условие должно выполняться для всех элементов
-- **= ANY** эквивалентно IN
-- **<> ALL** эквивалентно NOT IN
-- Для оптимальной производительности часто лучше использовать JOIN вместо ANY/ALL с подзапросами