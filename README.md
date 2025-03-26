Структура таблицы 

Bookings Бронирования
- book_ref
∗ book_date
∗ total_amount


AirportsАэропорты
- airport_code
∗ airport_name
∗ city
∗ longitude
∗ latitude
∗ timezone


Tickets Билеты
- ticket_no
∗ book_ref
∗ passenger_id
∗ passenger_name
◦ contact_data


Ticket_flights Перелеты
- ticket_no
- flight_id
∗ fare_conditions
∗ amount


Flights Рейсы
- flight_id
∗ flight_no
∗ scheduled_departure
∗ scheduled_arrival
∗ departure_airport
∗ arrival_airport
∗ status
∗ aircraft_code
◦ actual_departure
◦ actual_arrival


Aircrafts Самолеты
- aircraft_code
∗ model
∗ range


Boarding_passes Посадочные талоны
- ticket_no
- flight_id
∗ boarding_no
∗ seat_no


Seats Места
- aircraft_code
- seat_no
∗ fare_conditions

