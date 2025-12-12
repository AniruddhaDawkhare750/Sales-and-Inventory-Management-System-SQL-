USE Sales_and_Inventory_Management_System;
-- TO SEE HOW MANY TABLES IN THE DATABASE
SHOW tables;

-- TO SEE THE CONTENT IN TABLES
SELECT * from categories;
SELECT * from customers;
SELECT * from inventory;
SELECT * from products;
SELECT * from sales;
SELECT * from sales_items;

-- TO AUTOMATE THE MANUAL SYSTEM AND REDUCE THE COMPLEX OPERATION ALSO REDUCE THE NUMBER OF OPERATION USE TRIGGER
DELIMITER $$
CREATE TRIGGER update_sale
AFTER INSERT ON sales_items
FOR EACH ROW
BEGIN
    UPDATE inventory
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;
END
$$
DELIMITER ;

-- test trigger is working or not
INSERT INTO sales_items(sale_id, product_id, quantity, unit_price) values(1,1,2,50.00);
