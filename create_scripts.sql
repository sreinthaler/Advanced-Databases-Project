CREATE TABLE wildcat_customers (
customer_id NUMBER(32) PRIMARY KEY,
first_name VARCHAR2(32) NOT NULL,
last_name VARCHAR2(32) NOT NULL,
email VARCHAR2(42) NOT NULL UNIQUE,
user_name VARCHAR2(32) NOT NULL UNIQUE,
phone_number VARCHAR2(20) NOT NULL,
password VARCHAR2(32) NOT NULL,
account_creation_date TIMESTAMP NOT NULL
);

CREATE TABLE wildcat_shipping (
customer_id NUMBER(32) REFERENCES wildcat_customers(customer_id),
street_address VARCHAR2(61) NOT NULL,
city VARCHAR2(34) NOT NULL,
state_province VARCHAR2(2) NOT NULL,
zip VARCHAR2(10) NOT NULL,
country VARCHAR2(3) NOT NULL
);

CREATE TABLE wildcat_payment (
customer_id NUMBER(32) NOT NULL REFERENCES wildcat_customers(customer_id),
street_address VARCHAR2(61) NOT NULL,
city VARCHAR2(34) NOT NULL,
state_province VARCHAR2(2) NOT NULL,
zip VARCHAR2(10) NOT NULL,
country VARCHAR2(3) NOT NULL,
payment_id VARCHAR2(32) PRIMARY KEY
);

CREATE TABLE wildcat_products (
product_id NUMBER(32) PRIMARY KEY,
sku VARCHAR2(32) NOT NULL,
manufacturer VARCHAR2(30) NOT NULL,
finish VARCHAR2(150) NOT NULL,
title VARCHAR2(150) NOT NULL,
description VARCHAR2(150),
category VARCHAR2(29) NOT NULL
);

CREATE TABLE wildcat_orders (
order_id NUMBER(32) PRIMARY KEY,
customer_id NUMBER(32) NOT NULL REFERENCES wildcat_customers(customer_id),
status VARCHAR2(11) NOT NULL,
order_date TIMESTAMP NOT NULL,
site VARCHAR(3) NOT NULL
);

CREATE TABLE wildcat_order_items (
order_id NUMBER(32) NOT NULL REFERENCES wildcat_orders(order_id),
product_id NUMBER(32) NOT NULL REFERENCES wildcat_products(product_id),
unit_price NUMBER(8,2) NOT NULL,
quantity NUMBER(32) NOT NULL,
total_tax NUMBER(8,2) NOT NULL
);

CREATE TABLE wildcat_purchase_orders (
purchase_order_id NUMBER(32) PRIMARY KEY,
order_id NUMBER(32) NOT NULL REFERENCES wildcat_orders(order_id),
vendor VARCHAR(25) NOT NULL,
status VARCHAR(10) NOT NULL,
po_date TIMESTAMP NOT NULL
);

CREATE TABLE wildcat_purchase_order_items (
purchase_order_id NUMBER(32) NOT NULL REFERENCES wildcat_purchase_orders(purchase_order_id),
product_id NUMBER(28) NOT NULL,
quantity NUMBER(3) NOT NULL,
unit_cost NUMBER(8,2) NOT NULL
);