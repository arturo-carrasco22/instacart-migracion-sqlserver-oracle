-- 1. AISLES (134 filas - segundos)
INSERT INTO aisles SELECT * FROM "dbo"."aisles"@sqlserver_link;
COMMIT;
SELECT COUNT(*) AS aisles_migrados FROM aisles; -- esperado: 134

-- 2. DEPARTMENTS (21 filas - segundos)
INSERT INTO departments SELECT * FROM "dbo"."departments"@sqlserver_link;
COMMIT;
SELECT COUNT(*) AS departments_migrados FROM departments; -- esperado: 21

-- 3. PRODUCTS (49,688 filas - segundos)
INSERT INTO products SELECT * FROM "dbo"."products"@sqlserver_link;
COMMIT;
SELECT COUNT(*) AS products_migrados FROM products; -- esperado: 49688

-- 4. ORDERS (3,421,083 filas - varios minutos)
INSERT INTO orders SELECT * FROM "dbo"."orders"@sqlserver_link;
COMMIT;
SELECT COUNT(*) AS orders_migrados FROM orders; -- esperado: 3421083

-- 5. ORDER_PRODUCTS (32+ millones de filas - 1 a 2 horas)
--    Se migra por lotes de 100k order_ids para evitar errores de UNDO
--    NOTA: si se interrumpe, cambiar v_start al ultimo MAX(order_id) + 1

SET SERVEROUTPUT ON;

DECLARE
    v_start  NUMBER := 1;
    v_batch  NUMBER := 100000;
    v_max    NUMBER := 3421083;
    v_end    NUMBER;
    v_total  NUMBER := 0;
    v_sql    VARCHAR2(2000);
BEGIN
    WHILE v_start <= v_max LOOP
        v_end := v_start + v_batch - 1;

        v_sql := 'INSERT INTO order_products ' ||
                 'SELECT * FROM "dbo"."order_products"@sqlserver_link ' ||
                 'WHERE "order_id" BETWEEN ' || v_start || ' AND ' || v_end;

        EXECUTE IMMEDIATE v_sql;

        v_total := v_total + SQL%ROWCOUNT;
        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'order_id hasta ' || v_end || ' | total: ' || v_total
        );

        v_start := v_end + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('COMPLETADO. Total: ' || v_total);
END;
/

-- Verificacion final de todos los conteos
SELECT 'aisles'         AS tabla, COUNT(*) AS registros FROM aisles        UNION ALL
SELECT 'departments',             COUNT(*)              FROM departments    UNION ALL
SELECT 'products',                COUNT(*)              FROM products       UNION ALL
SELECT 'orders',                  COUNT(*)              FROM orders         UNION ALL
SELECT 'order_products',          COUNT(*)              FROM order_products
ORDER BY 1;
