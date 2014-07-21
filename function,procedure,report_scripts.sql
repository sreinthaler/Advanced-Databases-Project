SET SERVEROUTPUT ON


CREATE OR REPLACE PROCEDURE update_password
   (p_customer_id IN NUMBER, p_new_password IN VARCHAR2) IS
BEGIN
   IF COUNT(SELECT * FROM wildcat_customer WHERE customer_id = p_customer_id) THEN
      UPDATE wildcat_customers SET password = p_new_password WHERE customer_id = p_customer_id;
      dbms_output.put_line('Success.');
   ELSE
      RAISE no_customer;
   END IF;
EXCEPTION
   WHEN no_customer THEN
      dbms_output.put_line('Error: Customer not found.');
   WHEN OTHERS THEN
      dbms_output.put_line('Error.');
END;


CREATE OR REPLACE PROCEDURE add_order
   (p_order_id IN NUMBER, p_status IN VARCHAR2) IS
BEGIN
   IF COUNT(SELECT * FROM wildcat_orders WHERE order_id = p_order_id) = 1 THEN
      UPDATE wildcat_orders SET status = LOWER(p_status) WHERE order_id = p_order_id;
      dbms_output.put_line('Success.');
   ELSE
      RAISE no_order;
   END IF;
EXCEPTION
   WHEN no_order THEN
      dbms_output.put_line('Error: Order not found.');
   WHEN OTHERS THEN
      dbms_output.put_line('Error.');
END;


CREATE OR REPLACE FUNCTION daily_sales_totals 
   (p_site IN VARCHAR2, p_sales_date IN TIMESTAMP)
   RETURN NUMBER IS 
   v_daily_sales_total NUMBER;
BEGIN
   IF COUNT(SELECT FROM wildcat_orders WHERE order_date = p_sales_date AND status != 'cancelled') >= 1 THEN
      SELECT SUM(unit_price * quantity) INTO v_daily_sales_total
      FROM wildcat_orders, wildcat_order_items
      WHERE wildcat_orders.order_id = wildcat_order_items.order_id
      AND order_date = p_sales_date
      AND status != 'cancelled';
   END IF;
   RETURN v_daily_sales_total;
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line('Error.');
END;


CREATE OR REPLACE FUNCTION daily_profit
   (p_site IN VARCHAR2, p_sales_date IN TIMESTAMP)
   RETURN NUMBER IS
   v_daily_profit NUMBER;
   v_daily_sales NUMBER;
   v_daily_cogs NUMBER;
BEGIN
   IF COUNT(SELECT FROM wildcat_orders WHERE order_date = p_sales_date AND status != 'cancelled') >= 1 THEN
      SELECT SUM(unit_price * quantity) INTO v_daily_sales
      FROM wildcat_orders, wildcat_order_items
      WHERE wildcat_orders.order_id = wildcat_order_items.order_id
      AND order_date = p_sales_date
      AND status != 'cancelled';
      SELECT SUM(unit_cost * quantity) INTO v_daily_cogs
      FROM wildcat_purchase_orders, wildcat_purchase_order_items
      WHERE wildcat_purchase_orders.purchase_order_id = wildcat_purchase_order_items.purchase_order_id
      AND po_date = p_sales_date
      AND status != 'cancelled';
      v_daily_profit := v_daily_sales - v_daily_cogs
   END IF;
   RETURN v_daily_profit;
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line('Error.');
END;


SELECT product_id, number_sold
FROM (SELECT product_id, SUM(quantity) AS number_sold
      FROM wildcat_order_items, wildcat_orders
      WHERE wildcat_orders.order_id = wildcat_order_items.order_id
      AND site = 'USA'
      AND status != 'cancelled'
      GROUP BY product_id
      ORDER BY 2 DESC)
WHERE ROWNUM <= 10;

SELECT product_id, number_sold
FROM (SELECT product_id, SUM(quantity) AS number_sold
      FROM wildcat_order_items, wildcat_orders
      WHERE wildcat_orders.order_id = wildcat_order_items.order_id
      AND site = 'CAN'
      AND status != 'cancelled'
      GROUP BY product_id
      ORDER BY 2 DESC)
WHERE ROWNUM <= 10;