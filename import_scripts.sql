INSERT INTO wildcat_customers (customer_id, first_name, last_name, email, user_name, phone_number, "PASSWORD", account_creation_date)
SELECT "ID",NVL("FIRST",'(blank)'),NVL("LAST",'(blank)'),NVL(email,'(blank)'),NVL(username,'(blank)'),NVL(phone,'(blank)'),NVL("PASSWORD",'(blank)'),TO_TIMESTAMP(datecreated,'YYYY-MM-DD HH24:MI:SS.FF')
FROM temp_customer;

INSERT INTO wildcat_shipping (customer_id, street_address, city, state_province, zip, country)
SELECT userid,NVL(address,'(blank)'),NVL(city,'(blank)'),NVL(UPPER(state),'--'),NVL(zip,'00000'),'CAN'
FROM temp_shipping_can;

INSERT INTO wildcat_shipping (customer_id, street_address, city, state_province, zip, country)
SELECT userid,NVL(address,'(blank)'),NVL(city,'(blank)'),NVL(UPPER(state),'--'),NVL(zip,'00000'),'USA'
FROM temp_shipping_usa;

INSERT INTO wildcat_payment (customer_id, street_address, city, state_province, zip, country, payment_id)
SELECT userid,NVL(address,'(blank)'),NVL(city,'(blank)'),NVL(UPPER(state),'--'),NVL(zip,'00000'),'CAN',paymentid
FROM temp_payment_can;

INSERT INTO wildcat_payment (customer_id, street_address, city, state_province, zip, country, payment_id)
SELECT userid,NVL(address,'(blank)'),NVL(city,'(blank)'),NVL(UPPER(state),'--'),NVL(zip,'00000'),'USA',paymentid
FROM temp_payment_usa;

INSERT INTO wildcat_products (product_id,sku,manufacturer,"FINISH",title,description,"CATEGORY")
SELECT uniqueid,productid,NVL(manufacturer,'(blank)'),NVL("FINISH",'(blank)'),NVL(title,'(blank)'),NVL(description,'(blank)'),NVL("CATEGORY",'(blank)')
FROM temp_product;

INSERT INTO wildcat_orders (order_id,customer_id,status,order_date,site)
SELECT ordernum,userid,LOWER(status),TO_TIMESTAMP(dateordered,'YYYY-MM-DD HH24:MI:SS.FF'),DECODE(site,'wildcat.com','USA','wildcat.ca','CAN','--')
FROM temp_order;

INSERT INTO wildcat_order_items (order_id,product_id,unit_price,quantity,total_tax)
SELECT ordernum,productid,unitprice,qty,totaltax
FROM temp_order_item, temp_order
WHERE temp_order_item.cartid = temp_order.ordergroupid
AND productid IS NOT NULL;

INSERT INTO wildcat_purchase_orders (purchase_order_id,order_id,vendor,status,po_date)
SELECT purchaseorderid,orderid,NVL(vendor,'(blank)'),LOWER(status),TO_TIMESTAMP(podate,'YYYY-MM-DD HH24:MI:SS.FF')
FROM temp_po;

INSERT INTO wildcat_purchase_order_items (purchase_order_id,product_id,quantity,unit_cost)
SELECT pocartid,productuniqueid,qty,unitprice
FROM temp_po_item;