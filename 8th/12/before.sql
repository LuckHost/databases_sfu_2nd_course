

CREATE INDEX passenger_name_key ON tickets(passenger_name);

EXPLAIN ANALYZE
SELECT count(*) FROM tickets WHERE passenger_name = 'IVAN IVANOV';

