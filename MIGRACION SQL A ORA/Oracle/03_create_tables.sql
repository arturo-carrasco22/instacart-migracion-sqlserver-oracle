-- 1. AISLES
CREATE TABLE aisles (
    aisle_id  INT          NOT NULL,
    aisle     VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_aisles PRIMARY KEY (aisle_id)
) TABLESPACE tbsInstacart;

-- 2. DEPARTMENTS
CREATE TABLE departments (
    department_id  INT          NOT NULL,
    department     VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_departments PRIMARY KEY (department_id)
) TABLESPACE tbsInstacart;

-- 3. PRODUCTS
CREATE TABLE products (
    product_id    INT           NOT NULL,
    product_name  VARCHAR2(500) NOT NULL,
    aisle_id      INT,
    department_id INT,
    CONSTRAINT PK_products PRIMARY KEY (product_id)
) TABLESPACE tbsInstacart;

-- 4. ORDERS
CREATE TABLE orders (
    order_id               INT         NOT NULL,
    user_id                INT         NOT NULL,
    eval_set               VARCHAR2(20),
    order_number           INT,
    order_dow              INT,
    order_hour_of_day      INT,
    days_since_prior_order FLOAT,
    CONSTRAINT PK_orders PRIMARY KEY (order_id)
) TABLESPACE tbsInstacart;

-- 5. ORDER_PRODUCTS (prior + train unificados)
CREATE TABLE order_products (
    order_id          INT NOT NULL,
    product_id        INT NOT NULL,
    add_to_cart_order INT,
    reordered         INT,
    CONSTRAINT PK_order_products PRIMARY KEY (order_id, product_id)
) TABLESPACE tbsInstacart;

-- Verificar tablas creadas
SELECT table_name FROM user_tables ORDER BY table_name;
