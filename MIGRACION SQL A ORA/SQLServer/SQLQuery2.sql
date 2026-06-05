USE INSTACART_DB;
GO

CREATE TABLE aisles (
    aisle_id INT CONSTRAINT NN_AISLE_ID NOT NULL
                  CONSTRAINT PK_AISLE_ID PRIMARY KEY,
    aisle VARCHAR(100) NOT NULL
);

CREATE TABLE departments (
    department_id INT CONSTRAINT NN_DEPARTMENT_ID NOT NULL
                        CONSTRAINT PK_DEPARTMENT_ID PRIMARY KEY,
    department VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id INT CONSTRAINT NN_PRODUCT_ID NOT NULL
                    CONSTRAINT PK_PRODUCT_ID PRIMARY KEY,

    product_name VARCHAR(255) NOT NULL,

    aisle_id INT NOT NULL,

    department_id INT NOT NULL,

    CONSTRAINT FK_PRODUCTS_AISLES
        FOREIGN KEY (aisle_id)
        REFERENCES aisles(aisle_id),

    CONSTRAINT FK_PRODUCTS_DEPARTMENTS
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE orders (
    order_id INT CONSTRAINT NN_ORDER_ID NOT NULL
                  CONSTRAINT PK_ORDER_ID PRIMARY KEY,

    user_id INT NOT NULL,

    eval_set VARCHAR(20),

    order_number INT,

    order_dow INT,

    order_hour_of_day INT,

    days_since_prior_order FLOAT
);

CREATE TABLE order_products (
    order_id INT NOT NULL,

    product_id INT NOT NULL,

    add_to_cart_order INT,

    reordered BIT,

    CONSTRAINT PK_ORDER_PRODUCTS
        PRIMARY KEY (order_id, product_id),

    CONSTRAINT FK_OP_ORDERS
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT FK_OP_PRODUCTS
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);



