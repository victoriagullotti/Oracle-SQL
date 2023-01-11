show user;

CREATE VIEW sales_revenue AS
SELECT 
    s.cust_id, 
    SUM(s.quantity_sold) as items_number,
    ROUND(SUM(p.prod_min_price*s.quantity_sold)) money,
    ROUND(SUM(p.prod_min_price*s.quantity_sold) * 0.05) credit
FROM 
    sh.sales s INNER JOIN sh.products p on s.prod_id=p.prod_id
GROUP BY s.cust_id 
ORDER BY money DESC;

CREATE TABLE customers AS SELECT * FROM sh.customers;

SELECT SUM(cust_credit_limit) FROM customers;

DECLARE
  l_budget NUMBER := 1000000;
  -- cursor
  CURSOR c_sales IS SELECT  *  FROM sales_revenue ORDER BY money DESC;
  -- record    
  r_sales c_sales%ROWTYPE;
BEGIN
  -- reset credit limit of all customers
  UPDATE customers SET cust_credit_limit = 0;
  OPEN c_sales;
  LOOP
    FETCH  c_sales  INTO r_sales;
    EXIT WHEN c_sales%NOTFOUND;

    -- update credit for the current customer
    UPDATE 
        customers
    SET  
        cust_credit_limit = 
            CASE WHEN l_budget > r_sales.credit 
                        THEN r_sales.credit 
                            ELSE l_budget
            END
    WHERE 
        cust_id = r_sales.cust_id;

    --  reduce the budget for credit limit
    l_budget := l_budget - r_sales.credit;

    DBMS_OUTPUT.PUT_LINE( 'Customer id: ' ||r_sales.cust_id || ' Credit: ' || r_sales.credit || ' Remaining Budget: ' || l_budget );

    -- check the budget
    EXIT WHEN l_budget <= 0;
  END LOOP;

  CLOSE c_sales;
END;
/

SELECT * FROM sales_revenue  WHERE ROWNUM < 5 ORDER BY credit DESC;
SELECT cust_id, cust_credit_limit FROM customers WHERE cust_id IN (11407,12783,10747,42167);
SELECT SUM(cust_credit_limit) FROM customers;
