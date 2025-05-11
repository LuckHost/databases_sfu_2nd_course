-- В psql выполните:
\df

-- Или SQL-запрос:
SELECT proname AS function_name,
       pg_get_function_arguments(oid) AS arguments,
       pg_get_function_result(oid) AS return_type
FROM pg_proc
WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public');