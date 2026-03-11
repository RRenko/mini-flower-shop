Mini Flower Shop SQL Project

This project demonstrates a simple SQL database for a flower shop.

The database includes tables for:

- users
- products
- orders
- order_items

The project also includes analytical SQL queries to analyze shop data.

## Database Structure

The database contains the following tables:

**users**
- id
- name
- email
- created_at

**products**
- id
- title
- price
- stock
- is_active

**orders**
- id
- user_id
- created_at
- status

**order_items**
- id
- order_id
- product_id
- quantity
- price_at_time

## Analytical Queries

The project includes several analytical queries:

- Show all orders with user names
- Show products in each order
- Calculate total order amount
- Find the top spending user
- Show active products
- Find products with low stock
- Find users without orders

## Technologies Used

- SQL
- PostgreSQL (compatible)

## Author

Kirill Zakharenkov
