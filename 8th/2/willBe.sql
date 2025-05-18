
-- Если создать индекс на book_date в таблице Bookings
CREATE INDEX idx_bookings_date ON Bookings(book_date);

EXPLAIN ANALYZE
SELECT * FROM Bookings ORDER BY book_date;
-- Будет использоваться индекс idx_bookings_date