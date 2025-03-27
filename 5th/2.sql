WITH add_row AS (
  INSERT INTO aircrafts_tmp
  SELECT * FROM aircrafts
  RETURNING aircraft_code, model, range
)
INSERT INTO aircrafts_log
SELECT aircraft_code, model, range FROM add_row;