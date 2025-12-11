CREATE DATABASE Sales_and_Inventory_Management_System;
USE Sales_and_Inventory_Management_System;

-- 1. categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. products
CREATE TABLE products (
	product_id INT PRIMARY KEY AUTO_INCREMENT,
	product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    sell_price DECIMAL(10,2) NOT NULL,
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 3. inventory
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 4. customer
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(150) NOT NULL,
    city VARCHAR(100),
    contact VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 5. sales
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(30) DEFAULT 'CASH',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 6. sales item 
CREATE TABLE sales_items (
    sale_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

