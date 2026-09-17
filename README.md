# Sunrise Supermarket - Assignment One

## Student Information

**Name:** NKURUNZIZA Aimable  
**Student ID:** 29692  
**Group:** I  
**DBMS:** PostgreSQL  

## 1. Business Scenario

Sunrise Supermarket sells different products to customers. Customers can place orders, and each order can contain one or more products.

The purpose of this project is to use SQL to analyze customer orders, products, customer spending, and supermarket revenue.

The project uses four tables:

- `customers` - stores customer information such as name, email, and city.
- `products` - stores products, categories, and prices.
- `orders` - stores customer orders and order dates.
- `order_items` - stores the products and quantities included in each order.

The database contains:

- 7 customers
- 8 products
- 4 product categories
- 15 orders
- 30 order items

One customer does not have any orders so that the LEFT JOIN query can demonstrate how customers without orders are still displayed.

---

## 2. Database Structure

### Customers

The `customers` table contains customer identification, names, email addresses, and cities.

### Products

The `products` table contains product names, categories, and prices.

### Orders

The `orders` table connects customers with their orders and records the order dates.

### Order Items

The `order_items` table records which products were included in each order and their quantities.

---

# 3. JOIN Queries

## Question 1 - List every order with customer information

### SQL Query

```sql
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;