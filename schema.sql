CREATE TABLE IF NOT EXISTS raw_orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT,
  customer_name VARCHAR(100),
  country VARCHAR(50),
  product_id INT,
  product_name VARCHAR(100),
  category VARCHAR(50),
  unit_price NUMERIC(10,2),
  quantity INT,
  order_date DATE,
  store_id INT,
  store_city VARCHAR(100)
);

INSERT INTO raw_orders
  (customer_id, customer_name, country, product_id, product_name, category, unit_price, quantity, order_date, store_id, store_city)
VALUES
  (1, 'Alice',   'Cambodia', 101, 'Laptop',  'Electronics', 1200.00, 1, '2024-01-10', 1, 'Phnom Penh'),
  (2, 'Bob',     'Thailand', 102, 'Phone',   'Electronics',  800.00, 2, '2024-01-11', 2, 'Bangkok'),
  (1, 'Alice',   'Cambodia', 103, 'Mouse',   'Accessories',   25.00, 3, '2024-01-12', 1, 'Phnom Penh'),
  (3, 'Carol',   'Vietnam',  101, 'Laptop',  'Electronics', 1100.00, 1, '2024-01-13', 3, 'Hanoi'),
  (2, 'Bob',     'Thailand', 104, 'Tablet',  'Electronics',  600.00, 1, '2024-01-14', 2, 'Bangkok'),
  (4, 'David',   'Cambodia', 102, 'Phone',   'Electronics',  800.00, 1, '2024-01-15', 1, 'Phnom Penh'),
  (3, 'Carol',   'Vietnam',  103, 'Mouse',   'Accessories',   25.00, 5, '2024-01-15', 3, 'Hanoi'),
  (1, 'Alice',   'Singapore',101, 'Laptop',  'Electronics', 1200.00, 1, '2024-01-16', 4, 'Singapore');

CREATE TABLE IF NOT EXISTS dim_customer (
  customer_key SERIAL PRIMARY KEY,
  customer_id INT,
  customer_name VARCHAR(100),
  country VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_product (
  product_key SERIAL PRIMARY KEY,
  product_id INT,
  product_name VARCHAR(100),
  category VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_store (
  store_key SERIAL PRIMARY KEY,
  store_id INT,
  store_city VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dim_date (
  date_key INT PRIMARY KEY,
  full_date DATE,
  day_of_month INT,
  month INT,
  quarter INT,
  year INT
);

CREATE TABLE IF NOT EXISTS fact_sales (
  sale_id SERIAL PRIMARY KEY,
  customer_key INT REFERENCES dim_customer(customer_key),
  product_key INT REFERENCES dim_product(product_key),
  store_key INT REFERENCES dim_store(store_key),
  date_key INT REFERENCES dim_date(date_key),
  quantity INT,
  unit_price NUMERIC(10,2),
  total_amount NUMERIC(10,2)
);

ALTER TABLE dim_customer
  ADD COLUMN IF NOT EXISTS is_current BOOLEAN DEFAULT TRUE,
  ADD COLUMN IF NOT EXISTS valid_from DATE,
  ADD COLUMN IF NOT EXISTS valid_to DATE;

INSERT INTO dim_customer
  (customer_id, customer_name, country, is_current, valid_from, valid_to)
VALUES
  (1, 'Alice', 'Cambodia', TRUE, '2024-01-10', NULL);

UPDATE dim_customer
SET
  is_current = FALSE,
  valid_to = '2024-01-16'
WHERE customer_id = 1
  AND is_current = TRUE;

INSERT INTO dim_customer
  (customer_id, customer_name, country, is_current, valid_from, valid_to)
VALUES
  (1, 'Alice', 'Singapore', TRUE, '2024-01-16', NULL);

SELECT * FROM dim_customer WHERE customer_id = 1 ORDER BY valid_from;
