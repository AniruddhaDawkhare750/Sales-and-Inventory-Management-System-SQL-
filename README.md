#  Sales & Inventory Management System (SQL Project)

A complete **Sales & Inventory Management System** built using **MySQL**.  
This project demonstrates real-world database design, inventory tracking, sales processing, triggers, views, stored procedures, and analytical SQL queries.

---

##  Project Overview
This project simulates how real shops/supermarkets manage:

- Products & categories  
- Customer details  
- Inventory (stock levels)  
- Sales invoices (bill header + bill items)  
- Automatic stock deduction  
- Daily sales report  
- Business analytics  

The database is fully normalized and suitable for academic submission, practice, or portfolio use.

---

##  Database Design

### **Tables Included**
- `categories` – product group master (category id,name)  
- `products` – item details (name, price, category,cost price,selling price,is any stock is active or not and datetime)  
- `inventory` – stock levels & reorder logic  (product,stock level,record level)
- `customers` – customer information  (id,name,city,contact)
- `sales` – invoice header  (sale id,date,payment  method,customer_id)
- `sales_items` – invoice details (sale item id,sale id,product id,quantity,unit price)  

---

##  Features Implemented

###  **1. Automatic Stock Update (Trigger)**
A trigger reduces stock from the inventory table every time a product is sold.

###  **2. Daily Sales Report (Stored Procedure)**
A stored procedure returns all invoices for any given date.

###  **3. 40+ SQL Queries for Analysis**
Examples:
- Monthly revenue  
- Best-selling products  
- Low-stock alerts  
- Inventory valuation  
- Customer spending reports  

---

##  ER Diagram (Conceptual)

**Entities:**
- Category → Product  
- Product → Inventory  
- Customer → Sales → Sales Items  

**Relationships:**
- One category has many products  
- One sale has many sale items  
- One product can appear in many sale items  
- One customer can have many sales  

*<img width="954" height="586" alt="image" src="https://github.com/user-attachments/assets/cba2b05f-e818-4e29-8ff6-76b3dabd71e6" />
*

---

## 📄 SQL Files Included

| File | Purpose |
|------|---------|
| `schema.sql` | Creates all tables with constraints |
| `sample_data.sql` | Inserts sample datasets |
| `procedures.sql` | Stored procedures (daily sales) |
| `triggers.sql` | Trigger for auto stock update |
| `queries.sql` | 40+ business analytics SQL queries |

---


