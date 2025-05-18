-- -----------------------------------------------------------
-- Функция для обхода дерева снизу вверх, начиная с конкретного
-- узла.
-- ВАРИАНТ 1.
-- -----------------------------------------------------------
CREATE OR REPLACE FUNCTION up_tree_traversal(
 IN current_emp_nbr INTEGER )
 RETURNS TABLE( emp_nbr INTEGER, boss_emp_nbr INTEGER ) AS
$$
BEGIN
 -- Выбираем запись для текущего работника. На первой
 -- итерации это будет работник, с которого начинается
 -- обход дерева вверх.
 WHILE EXISTS ( SELECT *
 FROM Org_chart AS O
WHERE O.emp_nbr = current_emp_nbr )
 LOOP
 -- Если нужно, то выполним какое-либо действие
 -- для текущего узла дерева (т. е. для текущего
 -- работника). Для этого нужно процедуру SomeProc
 -- заменить на какую-то полезную процедуру.
 -- CALL SomeProc (current_emp_nbr);
 -- Добавим очередную пару (работник; начальник)
 -- к формируемому множеству таких пар.
 -- ПРИМЕЧАНИЕ. Этот оператор RETURN не завершает
 -- выполнение процедуры, а лишь ДОБАВЛЯЕТ очередную
 -- запись (строку) к результирующей таблице.
 RETURN QUERY SELECT O.emp_nbr, O.boss_emp_nbr
 FROM Org_chart AS O
WHERE O.emp_nbr = current_emp_nbr;

 -- Идем вверх по дереву к корню. Теперь текущим
 -- работником становится начальник только что
 -- обработанного работника, тем самым мы перемещаемся
 -- на один уровень вверх по дереву. Когда текущим
 -- работником станет главный начальник, у которого
 -- уже нет начальника, тогда результатом этого запроса
 -- будет current_emp_nbr = NULL, в результате чего
 -- условие цикла будет не выполнено, и цикл завершится.
 current_emp_nbr = ( SELECT O.boss_emp_nbr
 FROM Org_chart AS O
WHERE O.emp_nbr = current_emp_nbr );
 END LOOP;
END;
$$
LANGUAGE plpgsql;
-- -----------------------------------------------------------
-- Функция для обхода дерева снизу вверх, начиная с конкретного
-- узла.
-- ВАРИАНТ 2.
-- -----------------------------------------------------------
CREATE OR REPLACE FUNCTION up_tree_traversal2(
 IN current_emp_nbr INTEGER )
 RETURNS SETOF RECORD AS
$$
DECLARE
 -- В соответствии с выбранным типом результирующего значения,
 -- возвращаемого функцией, объявим переменную типа RECORD.
 rec RECORD;
BEGIN
 -- Выбираем запись для текущего работника. На первой
 -- итерации это будет работник, с которого начинается
 -- обход дерева вверх.
 WHILE EXISTS ( SELECT *
 FROM Org_chart AS O
WHERE O.emp_nbr = current_emp_nbr )
 LOOP
 -- Если нужно, то выполним какое-либо действие
 -- для текущего узла дерева (т. е. для текущего
 -- работника). Для этого нужно процедуру SomeProc
 -- заменить на какую-то полезную процедуру.
 -- CALL SomeProc (current_emp_nbr);
 -- Добавим очередную пару (работник; начальник)
 -- к формируемому множеству таких пар.

 SELECT O.emp_nbr, O.boss_emp_nbr
 INTO rec
 FROM Org_chart AS O
 WHERE O.emp_nbr = current_emp_nbr;
 -- ПРИМЕЧАНИЕ. Этот оператор RETURN не завершает
 -- выполнение процедуры, а лишь ДОБАВЛЯЕТ очередную
 -- запись к результирующему множеству.
 RETURN NEXT rec;

 -- Идем вверх по дереву к корню. Теперь текущим
 -- работником становится начальник только что
 -- обработанного работника, тем самым мы перемещаемся
 -- на один уровень вверх по дереву. Когда текущим
 -- работником станет главный начальник, у которого
 -- уже нет начальника, тогда результатом этого запроса
 -- будет current_emp_nbr = NULL, в результате чего
 -- условие цикла будет не выполнено, и цикл завершится.
 current_emp_nbr = ( SELECT O.boss_emp_nbr
 FROM Org_chart AS O
WHERE O.emp_nbr = current_emp_nbr );
 END LOOP;
 RETURN;
END;
$$
LANGUAGE plpgsql;


-- -----------------------------------------------------------
-- Функция для удаления поддерева.
-- -----------------------------------------------------------
CREATE OR REPLACE FUNCTION delete_subtree(
 IN dead_guy INTEGER ) RETURNS VOID AS
$$
-- Параметр dead_guy -- код работника, возглавляющего поддерево.
BEGIN
 -- Создадим врЕменную последовательность. Она нужна
 -- для того, чтобы формировать отрицательные значения
 -- для полей emp_nbr и boss_emp_nbr.

 -- У J. Celko использовалось значение -99999, которое
 -- записывалось в поля emp_nbr и boss_emp_nbr удаляемых
 -- записей. Это значение служило меткой удаляемой записи.
 -- Но мы добавили ограничение UNIQUE ( emp_nbr )
 -- в таблицу Org_chart. Поэтому теперь уже стало
 -- невозможно иметь более одной записи со значением поля
 -- emp_nbr равным -99999. Мы вынуждены записывать в это поле
 -- РАЗЛИЧНЫЕ значения в разных записях таблицы Org_chart.
 -- А такие значения удобно формировать, используя
 -- последовательность.
 CREATE TEMP SEQUENCE New_emp_nbr START WITH 1;
 -- Создадим временную таблицу.
 CREATE TEMP TABLE Working_table ( emp_nbr INTEGER NOT NULL )
 ON COMMIT DROP;
 -- Отложим проверку всех ограничений FOREIGN KEY
 -- до конца транзакции, иначе СУБД не позволит нам
 -- выполнять обновления полей emp_nbr и boss_emp_nbr:
 -- мы будем записывать в них отрицательные значения,
 -- а этих значений нет в таблице Personnel, на которую
 -- ссылается таблица Org_chart.
 SET CONSTRAINTS org_chart_emp_nbr_fkey,
 org_chart_boss_emp_nbr_fkey,
org_chart_boss_emp_nbr_fkey1
 DEFERRED;
 -- Пометим корень удаляемого поддерева и всех
 -- непосредственных подчиненных путем записи в поле
 -- emp_nbr или в поле boss_emp_nbr отрицательного значения,
 -- формируемого с помощью последовательности.
 UPDATE Org_chart
 SET emp_nbr = CASE WHEN emp_nbr = dead_guy
 THEN nextval( 'New_emp_nbr' ) * -1
 ELSE emp_nbr
 END,
 boss_emp_nbr = CASE WHEN boss_emp_nbr = dead_guy
 THEN nextval( 'New_emp_nbr' ) * -1
ELSE boss_emp_nbr
 END
 -- Условие WHERE означает, что выбираются лишь записи,
 -- в которых либо в поле emp_nbr, либо в поле boss_emp_nbr
 -- стоит значение идентификатора "главы" удаляемого поддерева.
 WHERE dead_guy IN ( emp_nbr, boss_emp_nbr );
 -- Помечаем листья дерева, т. е. записи для работников,
 -- не являющихся начальниками для других работников.
 WHILE EXISTS ( SELECT * FROM Org_chart
 WHERE boss_emp_nbr < 0 AND emp_nbr >= 0 )
 LOOP
 -- Получим список подчиненных следующего уровня.

 -- Сначала удалим все записи из временной таблицы.
 DELETE FROM Working_table;

 -- Выбираем подчиненных.
 INSERT INTO Working_table
 SELECT emp_nbr FROM Org_chart
 WHERE boss_emp_nbr < 0;
 -- Пометим следующий уровень подчиненных.
 -- Получаем очередное число из последовательности
 -- и умножаем его на -1, поскольку нам нужны
 -- отрицательные коды работников, т. к. именно
 -- отрицательные значения являются меткой удаляемой записи.
 UPDATE Org_chart
 SET emp_nbr = nextval( 'New_emp_nbr' ) * -1
 WHERE emp_nbr IN ( SELECT emp_nbr FROM Working_table );
 -- Помечаем начальников следующего уровня
 -- (при движении вниз по дереву).
 UPDATE Org_chart
 SET boss_emp_nbr = nextval( 'New_emp_nbr' ) * -1
 WHERE boss_emp_nbr IN ( SELECT emp_nbr FROM Working_table
);
 END LOOP;
 -- Удаляем все помеченные узлы.
 DELETE FROM Org_chart WHERE emp_nbr < 0;
 -- Снова активизируем все ограничения.
 SET CONSTRAINTS ALL IMMEDIATE;
 -- Удалим врЕменную последовательность.
 DROP SEQUENCE New_emp_nbr;
END;
$$
LANGUAGE plpgsql;


-- -----------------------------------------------------------
-- Функция для удаления элемента иерархии и продвижения
-- дочерних элементов на один уровень вверх (т. е. к "бабушке").
-- -----------------------------------------------------------
CREATE OR REPLACE FUNCTION delete_and_promote_subtree(
 IN dead_guy INTEGER ) RETURNS VOID AS
$$
-- Параметр dead_guy -- код работника, возглавляющего поддерево.
BEGIN
 -- Назначить нового начальника всем непосредственным
 -- подчиненным удаляемого работника.
 UPDATE Org_chart
 -- Получим код начальника для удаляемого работника.
 SET boss_emp_nbr = ( SELECT boss_emp_nbr
 FROM Org_chart
WHERE emp_nbr = dead_guy
 )
 WHERE boss_emp_nbr = dead_guy;
 -- Теперь удаляем работника. Все его подчиненные уже
 -- переподчинены вышестоящему начальнику.
 DELETE FROM Org_chart WHERE emp_nbr = dead_guy;
END;
$$
LANGUAGE plpgsql;
