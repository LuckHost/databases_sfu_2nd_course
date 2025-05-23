-- 1. Информация о таблицах и их столбцах
SELECT
    t.table_name,
    t.table_type,
    c.column_name,
    c.data_type,
    c.character_maximum_length,
    c.is_nullable,
    c.column_default,
    pgd.description AS column_comment
FROM
    information_schema.tables t
JOIN
    information_schema.columns c ON t.table_name = c.table_name
LEFT JOIN
    pg_catalog.pg_statio_all_tables st ON t.table_name = st.relname
LEFT JOIN
    pg_catalog.pg_description pgd ON pgd.objoid = st.relid AND pgd.objsubid = c.ordinal_position
WHERE
    t.table_schema = 'public'
ORDER BY
    t.table_name,
    c.ordinal_position;

-- 2. Информация о первичных ключах
SELECT
    tc.table_name,
    kc.column_name,
    tc.constraint_name
FROM
    information_schema.table_constraints tc
JOIN
    information_schema.key_column_usage kc ON tc.constraint_name = kc.constraint_name
WHERE
    tc.constraint_type = 'PRIMARY KEY' AND
    tc.table_schema = 'public'
ORDER BY
    tc.table_name,
    kc.column_name;

-- 3. Информация о внешних ключах
SELECT
    tc.table_name AS source_table,
    kc.column_name AS source_column,
    ccu.table_name AS target_table,
    ccu.column_name AS target_column,
    tc.constraint_name,
    rc.update_rule,
    rc.delete_rule
FROM
    information_schema.table_constraints tc
JOIN
    information_schema.key_column_usage kc ON tc.constraint_name = kc.constraint_name
JOIN
    information_schema.referential_constraints rc ON tc.constraint_name = rc.constraint_name
JOIN
    information_schema.constraint_column_usage ccu ON rc.unique_constraint_name = ccu.constraint_name
WHERE
    tc.constraint_type = 'FOREIGN KEY' AND
    tc.table_schema = 'public'
ORDER BY
    tc.table_name,
    kc.column_name;

-- 4. Информация об индексах
SELECT
    tablename AS table_name,
    indexname AS index_name,
    CASE WHEN indexdef LIKE '%UNIQUE%' THEN TRUE ELSE FALSE END AS is_unique
FROM
    pg_indexes
WHERE
    schemaname = 'public'
ORDER BY
    tablename,
    indexname;

-- 5. Информация о триггерах
SELECT
    t.event_object_table AS table_name,
    t.trigger_name,
    t.action_timing,
    t.event_manipulation,
    t.action_statement
FROM
    information_schema.triggers t
JOIN
    pg_trigger ON t.trigger_name = pg_trigger.tgname
JOIN
    pg_class ON pg_trigger.tgrelid = pg_class.oid
WHERE
    t.trigger_schema = 'public'
ORDER BY
    t.event_object_table,
    t.trigger_name;

-- 6. Информация о пользовательских функциях (включая триггерные)
SELECT
    n.nspname AS schema,
    p.proname AS function_name,
    pg_get_function_result(p.oid) AS return_type,
    pg_get_function_arguments(p.oid) AS arguments,
    l.lanname AS language,
    obj_description(p.oid, 'pg_proc') AS description
FROM
    pg_proc p
LEFT JOIN
    pg_namespace n ON p.pronamespace = n.oid
LEFT JOIN
    pg_language l ON p.prolang = l.oid
WHERE
    n.nspname = 'public'
ORDER BY
    p.proname;

-- 7. Информация о табличных ограничениях (CHECK, UNIQUE)
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    ccu.column_name,
    tc.is_deferrable,
    tc.initially_deferred
FROM
    information_schema.table_constraints tc
LEFT JOIN
    information_schema.constraint_column_usage ccu ON tc.constraint_name = ccu.constraint_name
WHERE
    tc.table_schema = 'public' AND
    tc.constraint_type IN ('CHECK', 'UNIQUE')
ORDER BY
    tc.table_name,
    tc.constraint_name;

