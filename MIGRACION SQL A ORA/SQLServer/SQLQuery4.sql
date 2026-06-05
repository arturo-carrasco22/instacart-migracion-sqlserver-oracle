USE INSTACART_DB;
GO

BULK INSERT aisles
FROM 'C:\INSTACART\csv\aisles.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

SELECT COUNT(*) AS aisles FROM aisles;

-- 2. departments
BULK INSERT departments
FROM 'C:\INSTACART\csv\departments.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

SELECT COUNT(*) AS departments FROM departments;
GO

--3.- Productos

BULK INSERT products
FROM 'C:\INSTACART\csv\products_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    MAXERRORS = 100
);

SELECT COUNT(*) AS products FROM products;

--4.- ORDERS
BULK INSERT orders
FROM 'C:\INSTACART\csv\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    BATCHSIZE = 50000
);

SELECT COUNT(*) AS orders FROM orders;

--
--5.- ORDER PRIOR

BULK INSERT order_products FROM 'C:\INSTACART\csv\order_products__prior.csv' WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='UTF-8', BATCHSIZE=100000, MAXERRORS=500);


-- 6.- Train 

BULK INSERT order_products FROM 'C:\INSTACART\csv\order_products__train.csv' WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='UTF-8', BATCHSIZE=100000, MAXERRORS=500);

-- MOSTRAR: 

SELECT 'aisles'                AS tabla, COUNT(*) AS registros FROM aisles 
UNION ALL 
SELECT 'departments',                   COUNT(*) FROM departments 
UNION ALL 
SELECT 'products',                      COUNT(*) FROM products 
UNION ALL 
SELECT 'orders',                        COUNT(*) FROM orders 
UNION ALL 
SELECT 'order_products',           COUNT(*) FROM order_products;