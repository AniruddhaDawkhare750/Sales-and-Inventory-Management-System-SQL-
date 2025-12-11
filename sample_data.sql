USE Sales_and_Inventory_Management_System;

INSERT INTO categories (category_name) VALUES
('Beverages'), ('Snacks'), ('Dairy'), ('Personal Care');

INSERT INTO products (product_name, category_id, cost_price, sell_price)
VALUES
('Coca Cola 500ml', 1, 20.00, 35.00),
('Pepsi 500ml', 1, 19.00, 34.00),
('Potato Chips 100g', 2, 15.00, 30.00),
('Chocolate Bar', 2, 25.00, 45.00),
('Milk 1L', 3, 35.00, 55.00),
('Cheese 200g', 3, 70.00, 110.00),
('Shampoo 200ml', 4, 80.00, 130.00),
('Soap Bar', 4, 15.00, 25.00);


INSERT INTO inventory (product_id, stock, reorder_level) VALUES
(1, 50, 20),
(2, 40, 20),
(3, 30, 15),
(4, 20, 10),
(5, 25, 10),
(6, 10, 5),
(7, 12, 5),
(8, 60, 20);

INSERT INTO customers (customer_name, city, contact) VALUES
('Rahul Wavdhane', 'Pune', '9876543210'),
('Tilak Verma', 'Delhi', '9876500000'),
('Arshdeep Singh', 'Bengaluru', '9898989898'),
('Karun Nair', 'Chennai', '9090909090'),
('Yash Daund','Mumbai','9325880568'),
('Vishwatej Shinde','Dharashiv','9308878767');

INSERT INTO sales (customer_id, sale_date, payment_method) VALUES
(1, '2025-12-01 10:15:00', 'CASH'),
(2, '2025-12-01 11:30:00', 'UPI'),
(1, '2025-12-02 09:45:00', 'CARD'),
(3, '2025-12-02 18:10:00', 'UPI'),
(4, '2025-12-03 20:05:00', 'CASH');


INSERT INTO sales_items (sale_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 35.00),
(1, 3, 1, 30.00),
(2, 5, 2, 55.00),
(2, 4, 3, 45.00),
(3, 1, 1, 35.00),
(3, 2, 2, 34.00),
(4, 7, 1, 130.00),
(4, 8, 4, 25.00),
(5, 6, 1, 110.00),
(5, 3, 2, 30.00);
