USE Sales_and_Inventory_Management_System;

-- CREATE THE PROCEDURE FOR SEE THE TRANSACTION ON SPECFIC DATE
DELIMITER $$
CREATE PROCEDURE sp_daily_sales (p_date DATE)
BEGIN
    SELECT *
    FROM (SELECT s.sale_id,s.sale_date,c.customer_name,c.city,
       SUM(si.quantity * si.unit_price) AS total_amount FROM sales s
		JOIN customers c ON s.customer_id = c.customer_id
		JOIN sales_items si ON s.sale_id = si.sale_id
		GROUP BY s.sale_id) AS DAILY_SALES
		WHERE DATE(sale_date) = p_date;
END$$
DELIMITER ;

-- test the procedure if the procedure give right answer or not.
call sp_daily_sales('2025-12-01');