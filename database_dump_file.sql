--
-- PostgreSQL database dump
--

-- Dumped from database version 16.13
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_product(character varying, character varying, integer, numeric, numeric, integer, text, character varying, date, character varying, integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.add_product(p_name character varying, p_distributor character varying, p_quantity integer, p_importprice numeric, p_sellprice numeric, p_categoryid integer, p_description text DEFAULT NULL::text, p_author character varying DEFAULT NULL::character varying, p_publishdate date DEFAULT NULL::date, p_isbn character varying DEFAULT NULL::character varying, p_age integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO product(
        name, distributor, description, addeddate, quantity,
        importprice, sellprice, age, isbn, author, publishdate, categoryid,
        isdeleted
    )
    VALUES (
        p_name, p_distributor, p_description, CURRENT_DATE, p_quantity,
        p_importprice, p_sellprice, p_age, p_isbn, p_author, p_publishdate, p_categoryid,
        FALSE -- isdeleted = 0
    );
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
$$;


ALTER FUNCTION public.add_product(p_name character varying, p_distributor character varying, p_quantity integer, p_importprice numeric, p_sellprice numeric, p_categoryid integer, p_description text, p_author character varying, p_publishdate date, p_isbn character varying, p_age integer) OWNER TO avnadmin;

--
-- Name: add_to_cart(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.add_to_cart(p_customer_id integer, p_product_id integer, p_quantity integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM cartitem
        WHERE customerid = p_customer_id AND productid = p_product_id
    ) THEN
        UPDATE cartitem
        SET quantity = quantity + p_quantity
        WHERE customerid = p_customer_id AND productid = p_product_id;
    ELSE
        INSERT INTO cartitem (customerid, productid, quantity)
        VALUES (p_customer_id, p_product_id, p_quantity);
    END IF;
END;
$$;


ALTER FUNCTION public.add_to_cart(p_customer_id integer, p_product_id integer, p_quantity integer) OWNER TO avnadmin;

--
-- Name: admin_login(text, text); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.admin_login(eusername text, epassword text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    count_customer INT;
BEGIN
    SELECT COUNT(*) INTO count_customer FROM customer
    WHERE customerusername = eusername AND customerpassword = epassword AND isdeleted = false;
    IF count_customer > 0 THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$;


ALTER FUNCTION public.admin_login(eusername text, epassword text) OWNER TO avnadmin;

--
-- Name: admin_signup(text, text, text, text); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.admin_signup(eusername text, epassword text, equestion text, eanswer text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    count_adminusername INT;
BEGIN
    SELECT COUNT(*) INTO count_adminusername FROM admin WHERE adminusername = eusername;
    IF count_adminusername > 0 THEN
        RETURN FALSE;
    END IF;

    INSERT INTO admin(adminusername, adminpassword, question, answer) VALUES (eusername, epassword, equestion, eanswer);
    RETURN TRUE;
END;
$$;


ALTER FUNCTION public.admin_signup(eusername text, epassword text, equestion text, eanswer text) OWNER TO avnadmin;

--
-- Name: ban_customer(character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.ban_customer(cususername character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- C?p nh?t c?t isdeleted d?a trˆn customerusername
  UPDATE customer
     SET isdeleted = TRUE
   WHERE customerusername = cusUsername;

  -- Tr? v? TRUE n?u c¢ ¡t nh?t 1 h…ng du?c c?p nh?t
  RETURN FOUND;
END;
$$;


ALTER FUNCTION public.ban_customer(cususername character varying) OWNER TO avnadmin;

--
-- Name: calculate_order_total(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.calculate_order_total() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    ctotalprice NUMERIC(15, 2);
BEGIN
    SELECT o.totalprice INTO ctotalprice
    FROM orders o
    WHERE o.orderid = NEW.orderid;

    ctotalprice:= ctotalprice + (SELECT SUM(ol.pricepurchase*ol.quantity)
    FROM orderline ol
    WHERE ol.orderid = NEW.orderid);

    UPDATE orders o
    SET totalprice = ctotalprice
    WHERE o.orderid = NEW.orderid;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.calculate_order_total() OWNER TO avnadmin;

--
-- Name: change_admin_password(character varying, character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.change_admin_password(p_username character varying, p_new_password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  old_password VARCHAR;
BEGIN
  SELECT adminpassword
  INTO   old_password
  FROM   admin
  WHERE  adminusername = p_username;

  IF NOT FOUND THEN  -- Neu khong tim thay username cua admin -> thoat
    RETURN FALSE;
  END IF;

  IF old_password = p_new_password THEN -- Neu mk cu v… mk moi giong nhau -> thoat 
    RETURN FALSE;
  END IF;

  UPDATE admin
  SET    adminpassword = p_new_password
  WHERE  adminusername = p_username;

  RETURN TRUE;
END;
$$;


ALTER FUNCTION public.change_admin_password(p_username character varying, p_new_password character varying) OWNER TO avnadmin;

--
-- Name: change_customer_password(character varying, character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.change_customer_password(p_username character varying, p_new_password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  old_password VARCHAR;
BEGIN
  SELECT customerpassword
  INTO   old_password
  FROM   customer
  WHERE  customerusername = p_username;

  IF NOT FOUND THEN  -- Neu khong tim thay username cua customer -> thoat
    RETURN FALSE;
  END IF;

  IF old_password = p_new_password THEN -- Neu mk cu v… mk moi giong nhau -> thoat 
    RETURN FALSE;
  END IF;

  UPDATE customer
  SET    customerpassword = p_new_password
  WHERE  customerusername = p_username;

  RETURN TRUE;
END;
$$;


ALTER FUNCTION public.change_customer_password(p_username character varying, p_new_password character varying) OWNER TO avnadmin;

--
-- Name: change_product_info(integer, character varying, character varying, integer, numeric, numeric, integer, text, character varying, date, character varying, integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.change_product_info(p_productid integer, p_name character varying, p_distributor character varying, p_quantity integer, p_importprice numeric, p_sellprice numeric, p_categoryid integer, p_description text DEFAULT NULL::text, p_author character varying DEFAULT NULL::character varying, p_publishdate date DEFAULT NULL::date, p_isbn character varying DEFAULT NULL::character varying, p_age integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ki?m tra xem s?n ph?m c¢ t?n t?i v… chua b? x¢a hay kh“ng
    IF NOT EXISTS (
        SELECT 1 
        FROM product 
        WHERE productid = p_productid 
        AND isdeleted = FALSE
    ) THEN
        RETURN FALSE; -- S?n ph?m kh“ng t?n t?i ho?c da b? x¢a
    END IF;

    -- Ki?m tra gi  tr? h?p l?
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        RETURN FALSE; -- Tˆn s?n ph?m kh“ng du?c d? tr?ng
    END IF;

    IF p_distributor IS NULL OR TRIM(p_distributor) = '' THEN
        RETURN FALSE; -- Nh… phƒn ph?i kh“ng du?c d? tr?ng
    END IF;

    IF p_quantity < 0 THEN
        RETURN FALSE; -- S? lu?ng kh“ng du?c ƒm
    END IF;

    IF p_importprice <= 0 THEN
        RETURN FALSE; -- Gi  nh?p ph?i l?n hon 0
    END IF;

    IF p_sellprice <= 0 THEN
        RETURN FALSE; -- Gi  b n ph?i l?n hon 0
    END IF;

    IF p_age < 0 THEN
        RETURN FALSE; -- D? tu?i kh“ng du?c ƒm
    END IF;

    -- Ki?m tra categoryid c¢ t?n t?i kh“ng
    IF p_categoryid IS NOT NULL AND NOT EXISTS (
        SELECT 1 
        FROM category 
        WHERE categoryid = p_categoryid
    ) THEN
        RETURN FALSE; -- Danh m?c kh“ng t?n t?i
    END IF;

    -- C?p nh?t th“ng tin s?n ph?m
    UPDATE product
    SET 
        name = p_name,
        distributor = p_distributor,
        description = p_description,
        addeddate = CURRENT_DATE,
        quantity = p_quantity,
        importprice = p_importprice,
        sellprice = p_sellprice,
        age = p_age,
        isbn = p_isbn,
        author = p_author,
        publishdate = p_publishdate,
        categoryid = p_categoryid
    WHERE productid = p_productid;

    RETURN TRUE; -- C?p nh?t th…nh c“ng
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE; -- L?i x?y ra
END;
$$;


ALTER FUNCTION public.change_product_info(p_productid integer, p_name character varying, p_distributor character varying, p_quantity integer, p_importprice numeric, p_sellprice numeric, p_categoryid integer, p_description text, p_author character varying, p_publishdate date, p_isbn character varying, p_age integer) OWNER TO avnadmin;

--
-- Name: clear_cart(integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.clear_cart(p_customer_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM cartitem
    WHERE customerid = p_customer_id;
END;
$$;


ALTER FUNCTION public.clear_cart(p_customer_id integer) OWNER TO avnadmin;

--
-- Name: create_order(bigint); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.create_order(ecustomerid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    eorderid BIGINT;
BEGIN
    INSERT INTO orders(customerid) 
    VALUES(ecustomerid)
    RETURNING orderid INTO eorderid;
    RETURN eorderid;
END;
$$;


ALTER FUNCTION public.create_order(ecustomerid bigint) OWNER TO avnadmin;

--
-- Name: create_order(bigint, integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.create_order(ecustomerid bigint, evoucherid integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    eorderid BIGINT;
    ediscount NUMERIC;
BEGIN
    SELECT discount INTO ediscount 
    FROM voucher
    WHERE voucherid = evoucherid;
    INSERT INTO orders(customerid, voucherid, totalprice) 
    VALUES(ecustomerid, evoucherid, - ediscount)
    RETURNING orderid INTO eorderid;
    RETURN eorderid;
END;
$$;


ALTER FUNCTION public.create_order(ecustomerid bigint, evoucherid integer) OWNER TO avnadmin;

--
-- Name: create_orderline(bigint, bigint, integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.create_orderline(eorderid bigint, eproductid bigint, equantity integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE esellprice NUMERIC(15,2);
BEGIN
    SELECT sellprice INTO esellprice
    FROM product 
    WHERE productid = eproductid;

    INSERT INTO orderline(orderid, productid, quantity, pricepurchase)
    VALUES (eorderid, eproductid, equantity, ROUND(equantity*esellprice::NUMERIC, 2));
END;
$$;


ALTER FUNCTION public.create_orderline(eorderid bigint, eproductid bigint, equantity integer) OWNER TO avnadmin;

--
-- Name: customer_login(text, text); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.customer_login(p_username text, p_password text) RETURNS TABLE(customerid integer, customername character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT c.customerid, c.customername
    FROM customer c
    WHERE c.customerusername = p_username
    AND c.customerpassword = p_password
    AND c.isdeleted = FALSE;

    IF NOT FOUND THEN
        RAISE NOTICE 'LOGIN FAILED';
    END IF;
END;
$$;


ALTER FUNCTION public.customer_login(p_username text, p_password text) OWNER TO avnadmin;

--
-- Name: customer_signup(text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.customer_signup(eusername text, epassword text, equestion text, eanswer text, ename text, eemail text, eaddress text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    count_customerusername INT;
BEGIN
    SELECT COUNT(*) INTO count_customerusername FROM customer WHERE customerusername = eusername ;
    IF count_customerusername > 0 THEN
        RETURN FALSE;
    END IF;

    INSERT INTO customer(customerusername, customerpassword, question, answer, customername, phonenumber, email, address) VALUES (eusername, epassword, equestion, eanswer , ename , eemail , eaddress );
    RETURN TRUE;
END;
$$;


ALTER FUNCTION public.customer_signup(eusername text, epassword text, equestion text, eanswer text, ename text, eemail text, eaddress text) OWNER TO avnadmin;

--
-- Name: customer_signup(text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.customer_signup(eusername text, epassword text, equestion text, eanswer text, ename text, eemail text, ephonenumber text, eaddress text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    count_customerusername INT;
BEGIN
    count_customerusername :=0;
    SELECT COUNT(*) INTO count_customerusername FROM customer WHERE customerusername = eusername ;
    IF count_customerusername > 0 THEN
        RETURN FALSE;
    END IF;

    INSERT INTO customer(customerusername, customerpassword, question, answer, customername, phonenumber, email, address) VALUES (eusername, epassword, equestion, eanswer , ename , ephonenumber, eemail , eaddress );
    RETURN TRUE;
END;
$$;


ALTER FUNCTION public.customer_signup(eusername text, epassword text, equestion text, eanswer text, ename text, eemail text, ephonenumber text, eaddress text) OWNER TO avnadmin;

--
-- Name: decrease_voucher_quantity(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.decrease_voucher_quantity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.voucherid IS NULL THEN
        RETURN NEW;
    END IF;

    UPDATE voucher
    SET remaining = remaining - 1
    WHERE voucherid = NEW.voucherid;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.decrease_voucher_quantity() OWNER TO avnadmin;

--
-- Name: delete_product(integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.delete_product(p_productid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ki?m tra xem s?n ph?m c¢ t?n t?i v… chua b? x¢a hay kh“ng
    IF NOT EXISTS (
        SELECT 1 
        FROM product 
        WHERE productid = p_productid 
        AND isdeleted = FALSE
    ) THEN
        RETURN FALSE; -- S?n ph?m kh“ng t?n t?i ho?c da b? x¢a
    END IF;

    -- C?p nh?t c?t isdeleted th…nh TRUE
    UPDATE product
    SET isdeleted = TRUE
    WHERE productid = p_productid;

    RETURN TRUE; -- X¢a th…nh c“ng
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE; -- L?i x?y ra
END;
$$;


ALTER FUNCTION public.delete_product(p_productid integer) OWNER TO avnadmin;

--
-- Name: delete_voucher(character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.delete_voucher(vcode character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE voucher AS v
     SET remaining = -1
   WHERE v.code = vCode;

  RETURN FOUND;
END;
$$;


ALTER FUNCTION public.delete_voucher(vcode character varying) OWNER TO avnadmin;

--
-- Name: find_by_category(text); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.find_by_category(ecategory text) RETURNS TABLE(productid integer, name character varying, distributor character varying, description text, addeddate date, quantity integer, importprice numeric, sellprice numeric, age integer, isbn character varying, author character varying, publishdate date, categoryid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.productid  ,
        p.name , 
        p.distributor , 
        p.description , 
        p.addeddate , 
        p.quantity , 
        p.importprice , 
        p.sellprice , 
        p.age ,  
        p.isbn , 
        p.author , 
        p.publishdate , 
        p.categoryid 
    FROM product p
    JOIN category c ON p.categoryid = c.categoryid
    WHERE c.categoryname = ecategory;
END;
$$;


ALTER FUNCTION public.find_by_category(ecategory text) OWNER TO avnadmin;

--
-- Name: find_product_by_restrict_age(integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.find_product_by_restrict_age(xsearch integer) RETURNS TABLE(xname character varying, xdistributor character varying, xdescription text, xage integer, xsell_price numeric, xauthor character varying, xisbn character varying, xpub_date date, xquantity integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      p.name,
      p.distributor,
      p.description,
      p.age,
      p.sellprice,
      p.author,
      p.isbn,
      p.publishdate,
      p.quantity
    FROM public.product p
    WHERE p.isdeleted IS DISTINCT FROM TRUE
      AND p.quantity > 0
      AND (p.age <= xsearch OR p.age IS NULL)
    ORDER BY p.sellprice ASC;
END;
$$;


ALTER FUNCTION public.find_product_by_restrict_age(xsearch integer) OWNER TO avnadmin;

--
-- Name: find_product_by_sell_price(numeric, numeric); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.find_product_by_sell_price(start_price numeric, end_price numeric) RETURNS TABLE(xname character varying, xdistributor character varying, xdescription text, xage integer, xsell_price numeric, xauthor character varying, xisbn character varying, xpub_date date, xquantity integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      p.name,
      p.distributor,
      p.description,
      p.age,
      p.sellprice,
      p.author,
      p.isbn,
      p.publishdate,
      p.quantity
    FROM product p
    WHERE p.isdeleted IS DISTINCT FROM TRUE
      AND p.quantity > 0
      AND p.sellprice BETWEEN start_price AND end_price
    ORDER BY p.sellprice ASC;
END;
$$;


ALTER FUNCTION public.find_product_by_sell_price(start_price numeric, end_price numeric) OWNER TO avnadmin;

--
-- Name: forgot_admin_password(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.forgot_admin_password(adusername character varying, adquestion character varying, adanswer character varying, adnewpassword character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  adquestion   VARCHAR;
  adanswer     VARCHAR;
  oldpassword  VARCHAR;
BEGIN
  SELECT question, answer INTO adquestion, adanswer
    FROM admin
   WHERE adminusername = adUsername;

  SELECT adminpassword INTO   oldpassword
    FROM   admin
  WHERE  adminusername = adUsername;

  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;

  IF adquestion <> adQuestion OR adanswer <> adAnswer THEN
    RETURN FALSE;
  END IF;

  
  IF oldpassword =  adNewPassword THEN
    RETURN FALSE;
  END IF;

  UPDATE admin AS a
     SET adminpassword = adNewPassword
   WHERE a.adminusername = adUsername;

  RETURN FOUND;
END;
$$;


ALTER FUNCTION public.forgot_admin_password(adusername character varying, adquestion character varying, adanswer character varying, adnewpassword character varying) OWNER TO avnadmin;

--
-- Name: forgot_customer_password(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.forgot_customer_password(cususername character varying, cusquestion character varying, cusanswer character varying, cusnewpassword character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  cusquestion   VARCHAR;
  cusanswer     VARCHAR;
  oldpassword  VARCHAR;
BEGIN
  SELECT question, answer INTO cusquestion, cusanswer
    FROM customer
   WHERE customerusername = cusUsername;

  SELECT customerpassword INTO oldpassword
    FROM  customer
  WHERE  customerusername = cusUsername;

  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;

  IF cusquestion <> cusQuestion OR cusanswer <> cusAnswer THEN
    RETURN FALSE;
  END IF;

  
  IF oldpassword =  cusNewPassword THEN
    RETURN FALSE;
  END IF;

  UPDATE customer AS c
     SET customerpassword = cusNewPassword
   WHERE c.customerusername = cusUsername;

  RETURN FOUND;
END;
$$;


ALTER FUNCTION public.forgot_customer_password(cususername character varying, cusquestion character varying, cusanswer character varying, cusnewpassword character varying) OWNER TO avnadmin;

--
-- Name: get_all_order_history(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_all_order_history() RETURNS TABLE(orderid integer, customerid integer, customername character varying, purchasedate timestamp without time zone, totalprice numeric, voucherid integer, orderlineid integer, productid integer, product_name character varying, quantity integer, pricepurchase numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.orderid,
        o.customerid,
        c.customername,
        o.purchasedate,
        o.totalprice,
        o.voucherid,
        ol.orderlineid,
        ol.productid,
        p.name AS product_name,
        ol.quantity,
        ol.pricepurchase
    FROM orders o
    JOIN customer c ON o.customerid = c.customerid
    JOIN orderline ol ON o.orderid = ol.orderid
    JOIN product p ON ol.productid = p.productid
    WHERE c.isdeleted = FALSE
    ORDER BY o.purchasedate DESC, o.orderid, ol.orderlineid;

    IF NOT FOUND THEN
        RAISE NOTICE 'No order history found.';
    END IF;
END;
$$;


ALTER FUNCTION public.get_all_order_history() OWNER TO avnadmin;

--
-- Name: get_cartitem(integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_cartitem(ecustomerid integer) RETURNS TABLE(productid integer, name character varying, sellprice numeric, quantity integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT p.productid, p.name, p.sellprice, ci.quantity FROM cartitem ci 
    JOIN product p ON ci.productid = p.productid 
    WHERE ci.customerid = ecustomerid;
    
END;
$$;


ALTER FUNCTION public.get_cartitem(ecustomerid integer) OWNER TO avnadmin;

--
-- Name: get_monthly_revenue(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_monthly_revenue() RETURNS TABLE(month text, revenue numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        TO_CHAR(purchasedate, 'YYYY-MM') AS month,
        SUM(totalprice) AS revenue
    FROM
        orders
    GROUP BY
        TO_CHAR(purchasedate, 'YYYY-MM')
    ORDER BY
        month;
END;
$$;


ALTER FUNCTION public.get_monthly_revenue() OWNER TO avnadmin;

--
-- Name: get_order_details(integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_order_details(p_orderid integer) RETURNS TABLE(orderid integer, customerid integer, totalprice numeric, purchasedate timestamp without time zone, voucherid integer, orderlineid integer, productid integer, quantity integer, pricepurchase numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.orderid,
        o.customerid,
        o.totalprice,
        o.purchasedate,
        o.voucherid,
        ol.orderlineid,
        ol.productid,
        ol.quantity,
        ol.pricepurchase
    FROM orders o
    JOIN orderline ol ON o.orderid = ol.orderid
    WHERE o.orderid = p_orderid;

    IF NOT FOUND THEN
        RAISE NOTICE 'No order found for orderid %', p_orderid;
    END IF;
END;
$$;


ALTER FUNCTION public.get_order_details(p_orderid integer) OWNER TO avnadmin;

--
-- Name: get_order_history_by_customer_id(integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_order_history_by_customer_id(p_customerid integer) RETURNS TABLE(orderid integer, purchasedate timestamp without time zone, totalprice numeric, orderlineid integer, productid integer, quantity integer, pricepurchase numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT o.orderid, o.purchasedate, o.totalprice, ol.orderlineid, ol.productid, ol.quantity, ol.pricepurchase
    FROM orders o
    JOIN orderline ol ON o.orderid = ol.orderid
    WHERE o.customerid = p_customerid;
END;
$$;


ALTER FUNCTION public.get_order_history_by_customer_id(p_customerid integer) OWNER TO avnadmin;

--
-- Name: get_orders_by_customer_name(text); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_orders_by_customer_name(p_name_search text) RETURNS TABLE(orderid integer, customerid integer, customername character varying, purchasedate timestamp without time zone, totalprice numeric, voucherid integer, orderlineid integer, productid integer, product_name character varying, quantity integer, pricepurchase numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.orderid,
        o.customerid,
        c.customername,
        o.purchasedate,
        o.totalprice,
        o.voucherid,
        ol.orderlineid,
        ol.productid,
        p.name AS product_name,
        ol.quantity,
        ol.pricepurchase
    FROM orders o
    JOIN customer c ON o.customerid = c.customerid
    JOIN orderline ol ON o.orderid = ol.orderid
    JOIN product p ON ol.productid = p.productid
    WHERE c.isdeleted = FALSE
    AND c.customername ILIKE '%' || p_name_search || '%'
    ORDER BY o.purchasedate DESC, o.orderid, ol.orderlineid;

    IF NOT FOUND THEN
        RAISE NOTICE 'No orders found for customers with name containing %', p_name_search;
    END IF;
END;
$$;


ALTER FUNCTION public.get_orders_by_customer_name(p_name_search text) OWNER TO avnadmin;

--
-- Name: get_purchase_counts(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_purchase_counts() RETURNS TABLE(customerid integer, purchase_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        orders.customerid,
        COUNT(*) as purchase_count
    FROM orders
    GROUP BY orders.customerid;
END;
$$;


ALTER FUNCTION public.get_purchase_counts() OWNER TO avnadmin;

--
-- Name: get_top_spending_customer(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_top_spending_customer() RETURNS TABLE(customerid integer, customername character varying, total_spent numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.customerid,
        c.customername,
        COALESCE(SUM(o.totalprice), 0) AS total_spent
    FROM customer c
    LEFT JOIN orders o ON c.customerid = o.customerid
    GROUP BY c.customerid, c.customername
    ORDER BY total_spent DESC
    LIMIT 3;
END;
$$;


ALTER FUNCTION public.get_top_spending_customer() OWNER TO avnadmin;

--
-- Name: get_voucher_by_code(text); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.get_voucher_by_code(ecode text) RETURNS TABLE(voucherid integer, code character varying, discount numeric, duration date, remaining integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM voucher v WHERE v.code = ecode AND v.remaining > 0 AND v.duration >= CURRENT_DATE;
END;
$$;


ALTER FUNCTION public.get_voucher_by_code(ecode text) OWNER TO avnadmin;

--
-- Name: insert_voucher(character varying, numeric, date, integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.insert_voucher(vcode character varying, vdiscount numeric, vduration date, vremaining integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  check_code INTEGER;
BEGIN

  SELECT voucherid INTO check_code
    FROM voucher
      WHERE code = vCode;

  IF FOUND THEN
    RETURN FALSE;
  END IF;

  IF vDiscount <= 0 THEN
    RETURN FALSE;
  END IF;

  IF vRemaining < 0 THEN
    RETURN FALSE;
  END IF;

  IF vDuration < CURRENT_DATE THEN
    RETURN FALSE;
  END IF;

  INSERT INTO voucher (code, discount, duration, remaining)
  VALUES (vCode, vDiscount, vDuration, vRemaining);

  RETURN TRUE;
END;
$$;


ALTER FUNCTION public.insert_voucher(vcode character varying, vdiscount numeric, vduration date, vremaining integer) OWNER TO avnadmin;

--
-- Name: place_order(integer, integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.place_order(ecustomerid integer, evoucherid integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    eorderid BIGINT;
    r_cart RECORD;
BEGIN
    eorderid := create_order(ecustomerid, evoucherid);

    FOR r_cart IN 
        SELECT productid, quantity 
        FROM cartitem 
        WHERE customerid = ecustomerid
    LOOP
        PERFORM create_orderline(eorderid, r_cart.productid, r_cart.quantity);
    END LOOP;

    PERFORM clear_cart(ecustomerid);

    RETURN eorderid;
END;
$$;


ALTER FUNCTION public.place_order(ecustomerid integer, evoucherid integer) OWNER TO avnadmin;

--
-- Name: top_books_sold_alltime(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.top_books_sold_alltime() RETURNS TABLE(xname character varying, xdistributor character varying, xdescription text, xsell_price numeric, xauthor character varying, xisbn character varying, xpub_date date, xtotal_sold bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      p.name,
      p.distributor,
      p.description,
      p.sellprice,
      p.author,
      p.isbn,
      p.publishdate,
      SUM(ol.quantity) AS xtotal_sold
    FROM product   AS p
    JOIN orderline AS ol ON ol.productid = p.productid
    JOIN orders    AS o  ON o.orderid    = ol.orderid
    WHERE o.purchasedate <= CURRENT_DATE
    GROUP BY
      p.name, p.distributor, p.description,
      p.sellprice, p.author, p.isbn, p.publishdate
    ORDER BY xtotal_sold DESC
    LIMIT 5;
END;
$$;


ALTER FUNCTION public.top_books_sold_alltime() OWNER TO avnadmin;

--
-- Name: trending(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.trending() RETURNS TABLE(productid integer, name character varying, distributor character varying, description text, addeddate date, quantity integer, importprice numeric, sellprice numeric, age integer, isbn character varying, author character varying, publishdate date, categoryid integer, total_sold bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.productid,
        p.name,
        p.distributor,
        p.description,
        p.addeddate,
        p.quantity,
        p.importprice,
        p.sellprice,
        p.age,
        p.isbn,
        p.author,
        p.publishdate,
        p.categoryid,
        COALESCE(SUM(ol.quantity), 0) AS total_sold
    FROM product p
    LEFT JOIN orderline ol ON p.productid = ol.productid
    WHERE p.isdeleted = FALSE
    GROUP BY p.productid, p.name, p.distributor, p.description, p.addeddate, 
             p.quantity, p.importprice, p.sellprice, p.age, p.isbn, 
             p.author, p.publishdate, p.categoryid
    ORDER BY total_sold DESC
    LIMIT 1;
END;
$$;


ALTER FUNCTION public.trending() OWNER TO avnadmin;

--
-- Name: trg_delete_all_vouchers(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.trg_delete_all_vouchers() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF delete_voucher(OLD.code) THEN
    RETURN OLD;
  ELSE
    RETURN NULL;
  END IF;
END;
$$;


ALTER FUNCTION public.trg_delete_all_vouchers() OWNER TO avnadmin;

--
-- Name: trg_insert_all_vouchers(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.trg_insert_all_vouchers() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF insert_voucher(NEW.code, NEW.discount, NEW.duration, NEW.remaining) THEN
    RETURN NEW;
  ELSE
    RETURN NULL;
  END IF;
END;
$$;


ALTER FUNCTION public.trg_insert_all_vouchers() OWNER TO avnadmin;

--
-- Name: trg_update_all_vouchers(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.trg_update_all_vouchers() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF update_voucher(NEW.code, NEW.discount, NEW.duration, NEW.remaining) THEN
    RETURN NEW;
  ELSE
    RETURN OLD;
  END IF;
END;
$$;


ALTER FUNCTION public.trg_update_all_vouchers() OWNER TO avnadmin;

--
-- Name: trg_update_customer_totalspent(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.trg_update_customer_totalspent() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE customer
    SET totalspent = totalspent + NEW.totalprice
    WHERE customerid = NEW.customerid;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_update_customer_totalspent() OWNER TO avnadmin;

--
-- Name: unban_customer(character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.unban_customer(cususername character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE customer
     SET isdeleted = FALSE
   WHERE customerusername = cusUsername;

  RETURN FOUND;
END;
$$;


ALTER FUNCTION public.unban_customer(cususername character varying) OWNER TO avnadmin;

--
-- Name: update_admin_in4(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.update_admin_in4(adusername character varying, adname character varying, adphonenum character varying, ademail character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
  IF adPhoneNum IS NOT NULL
     AND NOT (adPhoneNum ~ '^0[389][0-9]{8}$')
  THEN
    RETURN FALSE;
  END IF;
  IF adEmail IS NOT NULL
     AND NOT (adEmail ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
  THEN
    RETURN FALSE;
  END IF;
  UPDATE admin a
     SET adminname   = adName,
         phonenumber  = adPhoneNum,
         email       = adEmail
   WHERE a.adminusername = adUsername;

  RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.update_admin_in4(adusername character varying, adname character varying, adphonenum character varying, ademail character varying) OWNER TO avnadmin;

--
-- Name: update_all_totalspent(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.update_all_totalspent() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  cus_id INTEGER;
  total  NUMERIC(10,2);
BEGIN
  -- V•ng l?p qua t?ng customerid c¢ trong b?ng customer
  FOR cus_id IN SELECT customerid FROM customer LOOP

    -- T¡nh t?ng totalprice c?a t?t c? don h…ng c?a customer d¢
    SELECT SUM(totalprice)
      INTO total
      FROM orders
     WHERE customerid = cus_id;

    -- N?u kh“ng c¢ don h…ng n…o, g n total = 0
    IF total IS NULL THEN
      total := 0;
    END IF;

    -- C?p nh?t l?i totalspent cho customer
    UPDATE customer
       SET totalspent = total
     WHERE customerid = cus_id;

  END LOOP;
END;
$$;


ALTER FUNCTION public.update_all_totalspent() OWNER TO avnadmin;

--
-- Name: update_customer_in4(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.update_customer_in4(cususername character varying, cusname character varying, cusphonenum character varying, cusemail character varying, cusaddress character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN

  IF cusPhoneNum IS NOT NULL
     AND NOT (cusPhoneNum ~ '^0[389][0-9]{8}$')
  THEN
    RETURN FALSE;
  END IF;

  IF cusEmail IS NOT NULL
     AND NOT (cusEmail ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
  THEN
    RETURN FALSE;
  END IF;

  UPDATE customer AS c
     SET customername = cusName,
         phonenumber  = cusPhoneNum,
         email        = cusEmail,
         address      = cusAddress
   WHERE c.customerusername = cusUsername;

  RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.update_customer_in4(cususername character varying, cusname character varying, cusphonenum character varying, cusemail character varying, cusaddress character varying) OWNER TO avnadmin;

--
-- Name: update_product_price(integer, numeric, numeric); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.update_product_price(p_productid integer, p_new_importprice numeric, p_new_sellprice numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ki?m tra xem s?n ph?m c¢ t?n t?i v… chua b? x¢a hay kh“ng
    IF NOT EXISTS (
        SELECT 1 
        FROM product 
        WHERE productid = p_productid 
        AND isdeleted = FALSE
    ) THEN
        RETURN FALSE; -- S?n ph?m kh“ng t?n t?i ho?c da b? x¢a
    END IF;

    -- Ki?m tra gi  tr? gi  nh?p v… gi  b n ph?i l?n hon 0
    IF p_new_importprice <= 0 OR p_new_sellprice <= 0 THEN
        RETURN FALSE; -- Gi  kh“ng h?p l?
    END IF;

    -- C?p nh?t gi  nh?p v… gi  b n
    UPDATE product
    SET importprice = p_new_importprice,
        sellprice = p_new_sellprice
    WHERE productid = p_productid;

    RETURN TRUE; -- C?p nh?t th…nh c“ng
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE; -- L?i x?y ra
END;
$$;


ALTER FUNCTION public.update_product_price(p_productid integer, p_new_importprice numeric, p_new_sellprice numeric) OWNER TO avnadmin;

--
-- Name: update_product_quantity(); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.update_product_quantity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Gi?m s? lu?ng s?n ph?m trong b?ng product d?a trˆn quantity trong orderline
    UPDATE product
    SET quantity = quantity - NEW.quantity
    WHERE productid = NEW.productid;

    -- Ki?m tra s? lu?ng t? product d? d?m b?o kh“ng ƒm
    IF (SELECT quantity FROM product WHERE productid = NEW.productid) < 0 THEN
        RAISE NOTICE 'quantity < 0 for productid %', NEW.productid;
        -- C¢ th? thˆm logic rollback n?u c?n: RAISE EXCEPTION 'quantity < 0 for productid %, kh“ng th? ti?p t?c', NEW.productid;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_product_quantity() OWNER TO avnadmin;

--
-- Name: update_voucher(character varying, numeric, date, integer); Type: FUNCTION; Schema: public; Owner: avnadmin
--

CREATE FUNCTION public.update_voucher(vcode character varying, vdiscount numeric, vduration date, vremaining integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_old_discount  NUMERIC;
  v_old_duration  DATE;
  v_old_remaining INTEGER;
BEGIN
  IF vDiscount <= 0 THEN
    RETURN FALSE;
  END IF;

  IF vRemaining < 0 THEN
    RETURN FALSE;
  END IF;

  IF vDuration < CURRENT_DATE THEN
    RETURN FALSE;
  END IF;

  SELECT discount, duration, remaining
    INTO v_old_discount, v_old_duration, v_old_remaining
    FROM voucher
   WHERE code = vCode;

  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;

  IF v_old_discount = vDiscount
     AND v_old_duration = vDuration
     AND v_old_remaining = vRemaining
  THEN
    RETURN FALSE;
  END IF;

  IF v_old_remaining = -1
  THEN
    RETURN FALSE;
  END IF;

  UPDATE voucher
     SET discount  = vDiscount,
         duration  = vDuration,
         remaining = vRemaining
   WHERE code = vCode;

END;
$$;


ALTER FUNCTION public.update_voucher(vcode character varying, vdiscount numeric, vduration date, vremaining integer) OWNER TO avnadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.admin (
    adminid integer NOT NULL,
    adminusername character varying(255) NOT NULL,
    adminpassword character varying(255) NOT NULL,
    question character varying(225) NOT NULL,
    answer character varying(225) NOT NULL,
    adminname character varying(255),
    phonenumber character varying(255),
    email character varying(255),
    CONSTRAINT chk_admin_question CHECK (((question)::text = ANY ((ARRAY['What is your favorite color?'::character varying, 'What is your favorite sport?'::character varying, 'What is your favorite film?'::character varying, 'What is your favorite book?'::character varying])::text[])))
);


ALTER TABLE public.admin OWNER TO avnadmin;

--
-- Name: admin_adminid_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public.admin_adminid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_adminid_seq OWNER TO avnadmin;

--
-- Name: admin_adminid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public.admin_adminid_seq OWNED BY public.admin.adminid;


--
-- Name: voucher; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.voucher (
    voucherid integer NOT NULL,
    code character varying(255) NOT NULL,
    discount numeric(10,2) NOT NULL,
    duration date NOT NULL,
    remaining integer NOT NULL
);


ALTER TABLE public.voucher OWNER TO avnadmin;

--
-- Name: all_vouchers; Type: VIEW; Schema: public; Owner: avnadmin
--

CREATE VIEW public.all_vouchers AS
 SELECT code,
    discount,
    duration,
    remaining,
    voucherid
   FROM public.voucher
  WHERE (remaining <> '-1'::integer);


ALTER VIEW public.all_vouchers OWNER TO avnadmin;

--
-- Name: cartitem; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.cartitem (
    cartitemid integer NOT NULL,
    customerid integer NOT NULL,
    productid integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.cartitem OWNER TO avnadmin;

--
-- Name: cartitem_cartitemid_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public.cartitem_cartitemid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cartitem_cartitemid_seq OWNER TO avnadmin;

--
-- Name: cartitem_cartitemid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public.cartitem_cartitemid_seq OWNED BY public.cartitem.cartitemid;


--
-- Name: category; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.category (
    categoryid integer NOT NULL,
    categoryname character varying(100) NOT NULL
);


ALTER TABLE public.category OWNER TO avnadmin;

--
-- Name: category_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public.category_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_categoryid_seq OWNER TO avnadmin;

--
-- Name: category_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public.category_categoryid_seq OWNED BY public.category.categoryid;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.customer (
    customerid integer NOT NULL,
    customerusername character varying(255) NOT NULL,
    customerpassword character varying(255) NOT NULL,
    question character varying(225) NOT NULL,
    answer character varying(225) NOT NULL,
    customername character varying(255),
    phonenumber character varying(255),
    email character varying(255),
    address character varying(255),
    isdeleted boolean DEFAULT false,
    totalspent numeric(10,2) DEFAULT 0,
    CONSTRAINT chk_customer_question CHECK (((question)::text = ANY ((ARRAY['What is your favorite color?'::character varying, 'What is your favorite sport?'::character varying, 'What is your favorite film?'::character varying, 'What is your favorite book?'::character varying])::text[])))
);


ALTER TABLE public.customer OWNER TO avnadmin;

--
-- Name: customer_customerid_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public.customer_customerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_customerid_seq OWNER TO avnadmin;

--
-- Name: customer_customerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public.customer_customerid_seq OWNED BY public.customer.customerid;


--
-- Name: orderline; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.orderline (
    orderlineid integer NOT NULL,
    orderid integer NOT NULL,
    productid integer NOT NULL,
    quantity integer NOT NULL,
    pricepurchase numeric(10,2) NOT NULL
);


ALTER TABLE public.orderline OWNER TO avnadmin;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.orders (
    orderid integer NOT NULL,
    customerid integer NOT NULL,
    totalprice numeric(10,2),
    purchasedate timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    voucherid integer
);


ALTER TABLE public.orders OWNER TO avnadmin;

--
-- Name: product; Type: TABLE; Schema: public; Owner: avnadmin
--

CREATE TABLE public.product (
    productid integer NOT NULL,
    name character varying(255) NOT NULL,
    distributor character varying(255) NOT NULL,
    description text,
    addeddate date,
    quantity integer DEFAULT 0 NOT NULL,
    importprice numeric(10,2) NOT NULL,
    sellprice numeric(10,2) NOT NULL,
    age integer DEFAULT 0,
    isbn character varying(255),
    author character varying(255),
    publishdate date,
    categoryid integer,
    isdeleted boolean DEFAULT false
);


ALTER TABLE public.product OWNER TO avnadmin;

--
-- Name: order_details; Type: VIEW; Schema: public; Owner: avnadmin
--

CREATE VIEW public.order_details AS
 SELECT o.orderid,
    c.customerid,
    c.customername,
    o.purchasedate,
    o.totalprice,
    ol.orderlineid,
    p.name AS product_name,
    ol.quantity,
    ol.pricepurchase
   FROM (((public.orders o
     JOIN public.customer c ON ((o.customerid = c.customerid)))
     JOIN public.orderline ol ON ((o.orderid = ol.orderid)))
     JOIN public.product p ON ((ol.productid = p.productid)))
  WHERE (c.isdeleted = false);


ALTER VIEW public.order_details OWNER TO avnadmin;

--
-- Name: orderline_orderlineid_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public.orderline_orderlineid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orderline_orderlineid_seq OWNER TO avnadmin;

--
-- Name: orderline_orderlineid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public.orderline_orderlineid_seq OWNED BY public.orderline.orderlineid;


--
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_orderid_seq OWNER TO avnadmin;

--
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;


--
-- Name: product_productid_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public.product_productid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_productid_seq OWNER TO avnadmin;

--
-- Name: product_productid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public.product_productid_seq OWNED BY public.product.productid;


--
-- Name: view_all_users; Type: VIEW; Schema: public; Owner: avnadmin
--

CREATE VIEW public.view_all_users AS
 SELECT customerid,
    customerusername,
    customername,
    phonenumber,
    email,
    address,
    isdeleted,
    totalspent
   FROM public.customer;


ALTER VIEW public.view_all_users OWNER TO avnadmin;

--
-- Name: view_category_revenue; Type: VIEW; Schema: public; Owner: avnadmin
--

CREATE VIEW public.view_category_revenue AS
 SELECT c.categoryid,
    c.categoryname,
    sum(ol.quantity) AS total_quantity_sold,
    sum(((ol.quantity)::numeric * ol.pricepurchase)) AS total_revenue
   FROM (((public.category c
     JOIN public.product p ON ((c.categoryid = p.categoryid)))
     JOIN public.orderline ol ON ((p.productid = ol.productid)))
     JOIN public.orders o ON ((ol.orderid = o.orderid)))
  WHERE (p.isdeleted = false)
  GROUP BY c.categoryid, c.categoryname
  ORDER BY (sum(((ol.quantity)::numeric * ol.pricepurchase))) DESC;


ALTER VIEW public.view_category_revenue OWNER TO avnadmin;

--
-- Name: view_trending_category; Type: VIEW; Schema: public; Owner: avnadmin
--

CREATE VIEW public.view_trending_category AS
 SELECT c.categoryid,
    c.categoryname,
    sum(ol.quantity) AS total_quantity_sold,
    sum(((ol.quantity)::numeric * ol.pricepurchase)) AS total_revenue
   FROM (((public.category c
     JOIN public.product p ON ((c.categoryid = p.categoryid)))
     JOIN public.orderline ol ON ((p.productid = ol.productid)))
     JOIN public.orders o ON ((ol.orderid = o.orderid)))
  WHERE (p.isdeleted = false)
  GROUP BY c.categoryid, c.categoryname
  ORDER BY (sum(ol.quantity)) DESC;


ALTER VIEW public.view_trending_category OWNER TO avnadmin;

--
-- Name: voucher_voucherid_seq; Type: SEQUENCE; Schema: public; Owner: avnadmin
--

CREATE SEQUENCE public.voucher_voucherid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.voucher_voucherid_seq OWNER TO avnadmin;

--
-- Name: voucher_voucherid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avnadmin
--

ALTER SEQUENCE public.voucher_voucherid_seq OWNED BY public.voucher.voucherid;


--
-- Name: admin adminid; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.admin ALTER COLUMN adminid SET DEFAULT nextval('public.admin_adminid_seq'::regclass);


--
-- Name: cartitem cartitemid; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.cartitem ALTER COLUMN cartitemid SET DEFAULT nextval('public.cartitem_cartitemid_seq'::regclass);


--
-- Name: category categoryid; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.category ALTER COLUMN categoryid SET DEFAULT nextval('public.category_categoryid_seq'::regclass);


--
-- Name: customer customerid; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.customer ALTER COLUMN customerid SET DEFAULT nextval('public.customer_customerid_seq'::regclass);


--
-- Name: orderline orderlineid; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.orderline ALTER COLUMN orderlineid SET DEFAULT nextval('public.orderline_orderlineid_seq'::regclass);


--
-- Name: orders orderid; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- Name: product productid; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.product ALTER COLUMN productid SET DEFAULT nextval('public.product_productid_seq'::regclass);


--
-- Name: voucher voucherid; Type: DEFAULT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.voucher ALTER COLUMN voucherid SET DEFAULT nextval('public.voucher_voucherid_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

COPY public.admin (adminid, adminusername, adminpassword, question, answer, adminname, phonenumber, email) FROM stdin;
1	admin01	adminpass1	What is your favorite color?	milo	Nguyen Van A	0909123456	admin01@example.com
2	admin02	adminpass2	What is your favorite color?	hanoi	Tran Thi B	0911222333	admin02@example.com
36	hung123	hung	What is your favorite color?	hung	hung	hung	hung
37	ldfkjldsf	jkdsfkhjdshf	What is your favorite color?	jdsfj	\N	\N	\N
38	aaaa	aaaa	What is your favorite color?	aaaa	\N	\N	\N
39	uiiia	uiiia	What is your favorite color?	uiiia	\N	\N	\N
34	hung	hung@123	What is your favorite color?	hung	Luong Van Hung	0812345678	abcxyz@123.com
\.


--
-- Data for Name: cartitem; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

COPY public.cartitem (cartitemid, customerid, productid, quantity) FROM stdin;
1	1	1	2
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

COPY public.category (categoryid, categoryname) FROM stdin;
1	Ky thuat
2	Giai tri
3	Thieu nhi
4	Van hoc
5	Do choi
6	Sach giao khoa
40	Khoa hoc may tinh
41	Van hoc Viet Nam
42	Van hoc nuoc ngoai
43	Tam ly hoc
44	Ky nang song
45	Trinh tham
46	Kinh doanh
47	Marketing
48	Lich su
49	Triet hoc
50	Toan hoc
51	Vat ly
52	Hoa hoc
53	Sinh hoc
54	Ngoai ngu
55	Nau an
56	Manga
57	Hai huoc
58	Giao trinh dai hoc
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

COPY public.customer (customerid, customerusername, customerpassword, question, answer, customername, phonenumber, email, address, isdeleted, totalspent) FROM stdin;
57	hung	hung	What is your favorite book?	abc	hung	hung@gmail.com	0347826500	lung cu lang son	f	610118.00
1	user01	userpass1	What is your favorite color?	doraemon	Le Van Hung	0933444555	user01@example.com	123 ABC Street	f	3145000.00
2	user02	userpass2	What is your favorite color?	nguyen	Pham Thi Ngoc Anh	0944555666	user02@example.com	456 DEF Avenue	f	885000.00
51	nguyen van a	nguyenvana	What is your favorite color?	red	nguyen van a	a@gmail.com	0333333773	vietnam	f	743274.00
52	johndoe123	strongpassword	What is your favorite book?	1984	John Doe	0987654321	john@example.com	123 Tr?n Hung D?o, H… N?i	f	757848.00
53	nguyen van b	nguyenvanb	What is your favorite color?	green	nguyen van b	b@gmail.com	0333333454	vietnam	f	772422.00
55	nguyen van c	nguyenvanc	What is your favorite color?	none	nguyen van c	c@gmail.com	0344333434	vietnam	f	801570.00
56	nguyen van d	nguyenvand	What is your favorite color?	green	nguyen van d	d@gmail.com	0344888989	vietnam	f	816144.00
46	test	test	What is your favorite color?	blue	\N	\N	\N	\N	f	670404.00
36	luongvanhung	hung	What is your favorite color?	hung	\N	\N	\N	\N	f	524664.00
37	luongvanhung2	hung	What is your favorite color?	hung	hung	hung	hung	hung	f	539238.00
41	hoang1	hoang1	What is your favorite color?	hoang1	hoang1	0999888999	hoang1@abc	hoang1	f	597534.00
42	hoangdemo	hoangdemo	What is your favorite color?	hoangdemo	hoangdemo	hoangdemo	hoangdemo	hoangdemo	f	612108.00
44	hung123	hung	What is your favorite color?	hung	hung123	hung	hung	hung	f	641256.00
38	hoang	hoang	What is your favorite color?	yes	ThaiHoang	012345678798	abc@123	78maidich	f	553812.00
47	newuser123	securepassword	What is your favorite book?	Harry Potter	New User	0387654321	newuser@example.com	123 Test Street, Hanoi	f	684978.00
49	jjj	jjj	What is your favorite color?	red	jjj	hung@gmail.com	0347826500	jjj	f	714126.00
\.


--
-- Data for Name: orderline; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

COPY public.orderline (orderlineid, orderid, productid, quantity, pricepurchase) FROM stdin;
36	36	1	9	75000.00
1	1	1	2	150000.00
34	34	1	2	150000.00
38	38	1	3	225000.00
54	34	1	20	75000.00
55	34	35	1	28000.00
56	34	36	1	190000.00
57	34	34	1	12000.00
59	34	34	1	12000.00
61	34	1	2	150000.00
62	34	34	2	24000.00
63	34	34	1	12000.00
64	34	36	1	190000.00
65	34	35	1	28000.00
74	1	1	20	75000.00
75	1	1	20	75000.00
77	63	36	1	190000.00
78	64	34	1	12000.00
79	65	1	1	90000.00
80	65	49	1	150000.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

COPY public.orders (orderid, customerid, totalprice, purchasedate, voucherid) FROM stdin;
2	2	35000.00	2025-05-12 00:00:00	\N
35	1	140000.00	2025-06-10 00:00:00	\N
36	1	675000.00	2025-06-10 00:00:00	\N
37	2	175000.00	2025-06-10 00:00:00	\N
63	57	189990.00	2025-06-25 21:43:53.099663	39
64	57	11990.00	2025-06-25 21:47:56.659185	39
65	57	329990.00	2025-06-26 09:13:22.538647	39
38	2	675000.00	2025-06-10 00:00:00	\N
34	1	2620000.00	2025-06-10 00:00:00	\N
1	1	5400000.00	2025-05-10 00:00:00	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

COPY public.product (productid, name, distributor, description, addeddate, quantity, importprice, sellprice, age, isbn, author, publishdate, categoryid, isdeleted) FROM stdin;
41	Lich su Viet Nam	NXB Van hoa	Khai quat lich su Viet Nam qua cac thoi ky	2025-06-18	50	70000.00	110000.00	17	9781234567894	Do Van E	2022-01-01	5	f
36	Toi ac va Trung phat	NXB Van hoc	Tieu thuyet kinh dien cua nha van Fyodor Dostoevsky.	2025-06-15	93	150000.00	190000.00	0	\N	Fyodor Dostoevsky	\N	4	f
34	So tay Campus A5	NXB Hai Tien	\N	2025-06-15	294	8000.00	12000.00	0	\N	\N	\N	6	f
1	Lap trinh Python	NXB Cong Nghe	Sach hoc lap trinh Python	2025-06-18	458	60000.00	90000.00	0	9781234567898	Nguyen Van B	2023-11-11	1	f
49	Thiet ke do hoa voi AI	NXB My thuat	Cac ky thuat thiet ke do hoa su dung AI	2023-03-10	29	100000.00	150000.00	18	978-1234567892	Le Van C	2023-01-20	1	f
37	Sach Lap trinh Java	NXB Khoa hoc	Huong dan lap trinh Java co ban den nang cao	2025-06-18	100	80000.00	120000.00	18	9781234567890	Nguyen Van A	2021-05-15	1	f
38	Toan cao cap A1	NXB Giao duc	Giao trinh toan cao cap danh cho sinh vien ky thuat	2025-06-18	80	60000.00	95000.00	18	9781234567891	Tran Thi B	2020-08-10	2	f
42	Tam ly hoc dai cuong	NXB Dai hoc Quoc gia	Tong quan ve tam ly hoc hien dai	2025-06-18	90	85000.00	130000.00	19	9781234567895	Nguyen Thi F	2021-10-05	6	f
43	So tay cong nghe	NXB Cong nghiep	Tai lieu tham khao cong nghe moi	2025-06-18	100	95000.00	145000.00	21	9781234567896	Hoang Van G	2023-04-18	1	f
44	Vat ly dai cuong	NXB Giao duc	Giao trinh vat ly co ban cho dai hoc	2025-06-18	85	75000.00	115000.00	18	9781234567897	Ly Thi H	2020-11-30	2	f
45	Sach nau an gia dinh	NXB Am thuc	Tong hop cong thuc mon an gia dinh	2025-06-18	40	65000.00	99000.00	25	9781234567898	Ngo Van I	2019-06-06	3	f
46	Cham soc suc khoe	NXB Y hoc	Cam nang giu gin suc khoe hang ngay	2025-06-18	75	88000.00	135000.00	30	9781234567899	Mai Thi K	2022-09-15	4	f
35	Truyen tranh Conan Tap 100	NXB Kim Dong	Tap dac biet ky niem 100 tap cua series.	2025-06-15	245	20000.00	28000.00	0	\N	Gosho Aoyama	\N	3	f
40	Ky nang mem	NXB Thanh nien	Phat trien ky nang mem cho sinh vien va nguoi di lam	2025-06-18	49	40000.00	70000.00	20	9781234567893	Pham Thi D	2018-07-12	4	f
39	Tieng Anh Giao tiep	NXB Ngoai ngu	Tai lieu hoc tieng Anh giao tiep hang ngay	2025-06-18	59	50000.00	75000.00	16	9781234567892	Le Van C	2019-03-20	3	f
47	Lap trinh Python co ban	NXB Khoa hoc	Sach huong dan lap trinh Python tu co ban	2023-01-15	50	80000.00	120000.00	15	978-1234567890	Nguyen Van A	2022-10-01	1	f
48	Ky thuat lap trinh Web	NXB Giao duc	Huong dan xay dung website hien dai	2023-02-20	40	90000.00	135000.00	16	978-1234567891	Tran Thi B	2022-11-15	1	f
50	Xu ly du lieu voi SQL	NXB Khoa hoc	Huong dan xu ly du lieu bang SQL	2023-04-05	45	85000.00	127500.00	17	978-1234567893	Pham Thi D	2022-12-10	1	f
51	Lap trinh di dong Android	NXB Cong nghe	Phat trien ung dung di dong tren Android	2023-05-12	35	95000.00	142500.00	16	978-1234567894	Hoang Van E	2023-02-28	1	f
52	Bao mat mang co ban	NXB An ninh	Cac nguyen tac bao mat mang can ban	2023-06-18	25	75000.00	112500.00	18	978-1234567895	Vu Thi F	2023-03-15	1	f
53	IoT cho nguoi moi bat dau	NXB Khoa hoc	Gioi thieu ve Internet of Things	2023-07-22	20	88000.00	132000.00	16	978-1234567896	Do Van G	2023-04-10	1	f
54	Machine Learning co ban	NXB Tri thuc	Nhung khai niem co ban ve ML	2023-08-30	15	120000.00	180000.00	18	978-1234567897	Nguyen Thi H	2023-05-20	1	f
55	Quan tri he thong mang	NXB Cong nghe	Huong dan quan tri he thong mang doanh nghiep	2023-09-14	18	110000.00	165000.00	19	978-1234567898	Tran Van I	2023-06-15	1	f
56	Thiet ke database hieu qua	NXB Khoa hoc	Cac nguyen tac thiet ke CSDL	2023-10-05	22	95000.00	142500.00	17	978-1234567899	Le Thi K	2023-07-10	1	f
57	Lap trinh game voi Unity	NXB Giai tri	Tao game 2D/3D bang Unity	2023-11-11	28	105000.00	157500.00	16	978-1234567900	Phan Van L	2023-08-05	1	f
58	Blockchain va ung dung	NXB Tai chinh	Tim hieu ve cong nghe Blockchain	2023-12-03	12	115000.00	172500.00	18	978-1234567901	Ho Thi M	2023-09-20	1	f
59	Kien truc may tinh	NXB Giao duc	Co so ly thuyet ve kien truc may tinh	2024-01-15	20	98000.00	147000.00	19	978-1234567902	Nguyen Van N	2023-10-15	1	f
60	Big Data voi Hadoop	NXB Khoa hoc	Xu ly du lieu lon voi Hadoop	2024-02-20	15	125000.00	187500.00	18	978-1234567903	Tran Thi O	2023-11-10	1	f
61	An toan thong tin	NXB An ninh	Cac chuan an toan thong tin	2024-03-05	25	90000.00	135000.00	17	978-1234567904	Le Van P	2023-12-05	1	f
62	Truyen cuoi hay nhat	NXB Giai tri	Tuyen tap truyen cuoi dan gian	2023-01-10	60	50000.00	75000.00	12	978-1234567905	Nhieu tac gia	2022-09-15	2	f
63	Cau do vui	NXB Thieu nhi	1001 cau do hay cho tre em	2023-02-15	55	45000.00	67500.00	8	978-1234567906	Nguyen Van Q	2022-10-20	2	f
64	Truyen tranh hai huoc	NXB My thuat	Truyen tranh hai huoc cho moi lua tuoi	2023-03-20	40	60000.00	90000.00	10	978-1234567907	Tran Thi R	2022-11-25	2	f
65	Tro choi dan gian	NXB Van hoa	Cac tro choi dan gian Viet Nam	2023-04-25	35	55000.00	82500.00	12	978-1234567908	Le Van S	2022-12-30	2	f
66	Hat karaoke hay	NXB Am nhac	Tuyen tap bai hat karaoke pho bien	2023-05-30	30	65000.00	97500.00	15	978-1234567909	Pham Thi T	2023-01-05	2	f
67	Truyen ma kinh di	NXB Giai tri	Tuyen tap truyen ma hay nhat	2023-06-05	25	70000.00	105000.00	16	978-1234567910	Hoang Van U	2023-02-10	2	f
68	Meo vui cuoc song	NXB Doi song	Nhung meo vui de cuoc song de dang hon	2023-07-10	45	48000.00	72000.00	14	978-1234567911	Vu Thi V	2023-03-15	2	f
69	Truyen ngan hai huoc	NXB Van hoc	Tuyen tap truyen ngan hai huoc	2023-08-15	38	52000.00	78000.00	15	978-1234567912	Do Van X	2023-04-20	2	f
70	100 cau do kho	NXB Tri tue	Cau do tri tue thu vi	2023-09-20	20	58000.00	87000.00	16	978-1234567913	Nguyen Thi Y	2023-05-25	2	f
71	Truyen cuoi ngan	NXB Giai tri	Truyen cuoi ngan cho gio giai lao	2023-10-25	50	40000.00	60000.00	12	978-1234567914	Tran Van Z	2023-06-30	2	f
72	Be hoc chu cai	NXB Giao duc	Sach giup be lam quen voi chu cai	2023-01-05	100	30000.00	45000.00	3	978-1234567915	Nguyen Thi AA	2022-08-10	3	f
73	Be tap to mau	NXB Thieu nhi	Sach to mau cho tre mam non	2023-02-10	80	35000.00	52500.00	4	978-1234567916	Tran Van BB	2022-09-15	3	f
74	Truyen co tich Viet Nam	NXB Van hoc	Tuyen tap truyen co tich hay	2023-03-15	70	40000.00	60000.00	5	978-1234567917	Le Thi CC	2022-10-20	3	f
75	Be hoc dem so	NXB Giao duc	Giup be nhan biet va dem so	2023-04-20	90	32000.00	48000.00	4	978-1234567918	Pham Van DD	2022-11-25	3	f
76	Truyen tranh thieu nhi	NXB My thuat	Truyen tranh mau cho be	2023-05-25	60	45000.00	67500.00	5	978-1234567919	Hoang Thi EE	2022-12-30	3	f
77	Bai hat thieu nhi	NXB Am nhac	Tuyen tap bai hat thieu nhi hay	2023-06-30	50	38000.00	57000.00	4	978-1234567920	Vu Van FF	2023-01-05	3	f
78	Truyen ngu ngon	NXB Van hoc	Truyen ngu ngon y nghia cho be	2023-07-05	65	42000.00	63000.00	6	978-1234567921	Do Thi GG	2023-02-10	3	f
79	Be tap viet	NXB Giao duc	Luyen viet chu cho tre nho	2023-08-10	75	36000.00	54000.00	5	978-1234567922	Nguyen Van HH	2023-03-15	3	f
80	Truyen co tich the gioi	NXB Van hoc	Truyen co tich cac nuoc	2023-09-15	55	48000.00	72000.00	6	978-1234567923	Tran Thi II	2023-04-20	3	f
81	Tro choi phat trien tri tue	NXB Thieu nhi	Tro choi giup be thong minh hon	2023-10-20	40	52000.00	78000.00	5	978-1234567924	Le Van JJ	2023-05-25	3	f
82	Sach hoc tieng Anh cho be	NXB Ngoai ngu	Lam quen tieng Anh co ban	2023-11-25	45	55000.00	82500.00	6	978-1234567925	Pham Thi KK	2023-06-30	3	f
83	Truyen tranh hoc duong	NXB My thuat	Truyen tranh ve doi hoc sinh	2023-12-30	50	50000.00	75000.00	7	978-1234567926	Hoang Van LL	2023-07-05	3	f
84	Be tap ke chuyen	NXB Giao duc	Ren luyen ky nang ke chuyen	2024-01-05	60	42000.00	63000.00	6	978-1234567927	Vu Thi MM	2023-08-10	3	f
85	Truyen than thoai	NXB Van hoc	Truyen than thoai hay cho be	2024-02-10	35	58000.00	87000.00	7	978-1234567928	Do Van NN	2023-09-15	3	f
86	Bai tap phat trien tu duy	NXB Giao duc	Bai tap nang cao tu duy cho tre	2024-03-15	30	60000.00	90000.00	7	978-1234567929	Nguyen Thi OO	2023-10-20	3	f
87	Tieu thuyet tinh cam	NXB Van hoc	Cau chuyen tinh cam cam dong	2023-01-20	40	70000.00	105000.00	16	978-1234567930	Tran Van PP	2022-09-25	4	f
88	Truyen ngan dac sac	NXB Van hoc	Tuyen tap truyen ngan hay	2023-02-25	35	65000.00	97500.00	15	978-1234567931	Le Thi QQ	2022-10-30	4	f
89	Tho tinh chon loc	NXB Van hoa	Tuyen tap tho tinh hay nhat	2023-03-30	30	60000.00	90000.00	14	978-1234567932	Pham Van RR	2022-12-05	4	f
90	Tieu thuyet hien dai	NXB Van hoc	Tieu thuyet ve xa hoi hien dai	2023-05-05	25	80000.00	120000.00	18	978-1234567933	Hoang Thi SS	2023-01-10	4	f
91	Truyen ky uc	NXB Van hoc	Ky uc tuoi tho cam dong	2023-06-10	45	55000.00	82500.00	16	978-1234567934	Vu Van TT	2023-02-15	4	f
92	Tuyen tap tan van	NXB Van hoc	Tan van dac sac cac tac gia	2023-07-15	20	75000.00	112500.00	17	978-1234567935	Do Thi UU	2023-03-20	4	f
93	Tieu thuyet lich su	NXB Van hoc	Tieu thuyet ve nhan vat lich su	2023-08-20	15	90000.00	135000.00	18	978-1234567936	Nguyen Van VV	2023-04-25	4	f
94	Truyen duong dai	NXB Van hoc	Truyen dai ky ve hanh phuc	2023-09-25	18	85000.00	127500.00	17	978-1234567937	Tran Thi WW	2023-05-30	4	f
95	Tuyen tap but ky	NXB Van hoc	But ky cua nhieu tac gia	2023-10-30	22	70000.00	105000.00	16	978-1234567938	Le Van XX	2023-07-05	4	f
96	Tho moi 2023	NXB Van hoa	Tuyen tap tho moi nhat	2023-12-05	28	65000.00	97500.00	15	978-1234567939	Pham Thi YY	2023-08-10	4	f
97	Sach gap hinh 3D	NXB Do choi	Sach tao hinh 3D thu vi	2023-01-25	50	60000.00	90000.00	6	978-1234567940	Hoang Van ZZ	2022-10-05	5	f
98	Sach phat nhac	NXB Do choi	Sach co nut bam phat nhac	2023-02-28	40	80000.00	120000.00	4	978-1234567941	Vu Thi AAA	2022-11-10	5	f
99	Sach to mau phat sang	NXB Do choi	To mau va phat sang ky dieu	2023-04-05	35	75000.00	112500.00	5	978-1234567942	Do Van BBB	2022-12-15	5	f
100	Sach xep hinh Lego	NXB Do choi	Huong dan xep hinh Lego	2023-05-10	30	90000.00	135000.00	7	978-1234567943	Nguyen Thi CCC	2023-01-20	5	f
101	Sach tro choi tuong tac	NXB Do choi	Sach co cac tro choi tuong tac	2023-06-15	25	85000.00	127500.00	6	978-1234567944	Tran Van DDD	2023-02-25	5	f
102	Toan lop 1	NXB Giao duc	Sach giao khoa Toan lop 1	2023-01-30	200	25000.00	37500.00	7	978-1234567945	Bo Giao duc	2022-08-15	6	f
103	Tieng Viet lop 2	NXB Giao duc	Sach giao khoa Tieng Viet lop 2	2023-03-05	180	28000.00	42000.00	8	978-1234567946	Bo Giao duc	2022-08-15	6	f
104	Tu nhien Xa hoi lop 3	NXB Giao duc	Sach giao khoa TNXH lop 3	2023-04-10	150	30000.00	45000.00	9	978-1234567947	Bo Giao duc	2022-08-15	6	f
105	Toan lop 4	NXB Giao duc	Sach giao khoa Toan lop 4	2023-05-15	160	32000.00	48000.00	10	978-1234567948	Bo Giao duc	2022-08-15	6	f
106	Tieng Anh lop 5	NXB Giao duc	Sach giao khoa Tieng Anh lop 5	2023-06-20	140	35000.00	52500.00	11	978-1234567949	Bo Giao duc	2022-08-15	6	f
107	Khoa hoc lop 4	NXB Giao duc	Sach giao khoa Khoa hoc lop 4	2023-07-25	130	33000.00	49500.00	10	978-1234567950	Bo Giao duc	2022-08-15	6	f
108	Lich su Dia ly lop 5	NXB Giao duc	Sach giao khoa LSDL lop 5	2023-08-30	120	36000.00	54000.00	11	978-1234567951	Bo Giao duc	2022-08-15	6	f
109	Toan lop 6	NXB Giao duc	Sach giao khoa Toan lop 6	2023-10-05	110	40000.00	60000.00	12	978-1234567952	Bo Giao duc	2022-08-15	6	f
110	Ngu van lop 7	NXB Giao duc	Sach giao khoa Ngu van lop 7	2023-11-10	100	42000.00	63000.00	13	978-1234567953	Bo Giao duc	2022-08-15	6	f
111	Vat ly lop 8	NXB Giao duc	Sach giao khoa Vat ly lop 8	2023-12-15	90	45000.00	67500.00	14	978-1234567954	Bo Giao duc	2022-08-15	6	f
112	Lap trinh C++ nang cao	NXB Khoa hoc	Lap trinh C++ tu trung cap den nang cao	2023-01-10	30	95000.00	142500.00	16	978-1234567955	Nguyen Van EEE	2022-09-20	40	f
113	Thuat toan va giai thuat	NXB Khoa hoc	Co so thuat toan cho lap trinh vien	2023-02-15	25	110000.00	165000.00	17	978-1234567956	Tran Thi FFF	2022-10-25	40	f
114	He dieu hanh Linux	NXB Cong nghe	Tim hieu va su dung Linux	2023-03-20	20	100000.00	150000.00	18	978-1234567957	Le Van GGG	2022-11-30	40	f
115	Machine Learning nang cao	NXB Khoa hoc	Cac ky thuat ML nang cao	2023-04-25	15	130000.00	195000.00	19	978-1234567958	Pham Thi HHH	2023-01-05	40	f
116	Lap trinh Web voi React	NXB Cong nghe	Xay dung Web app voi ReactJS	2023-05-30	22	115000.00	172500.00	17	978-1234567959	Hoang Van III	2023-02-10	40	f
117	Kien truc phan mem	NXB Khoa hoc	Thiet he phan mem chuyen nghiep	2023-07-05	18	120000.00	180000.00	18	978-1234567960	Vu Thi JJJ	2023-03-15	40	f
118	Big Data Analytics	NXB Khoa hoc	Phan tich du lieu lon trong thuc te	2023-08-10	12	140000.00	210000.00	19	978-1234567961	Do Van KKK	2023-04-20	40	f
119	Lap trinh Game 3D	NXB Cong nghe	Phat trien game 3D voi Unity	2023-09-15	15	125000.00	187500.00	18	978-1234567962	Nguyen Thi LLL	2023-05-25	40	f
120	Blockchain nang cao	NXB Tai chinh	Ung dung Blockchain trong tai chinh	2023-10-20	10	150000.00	225000.00	19	978-1234567963	Tran Van MMM	2023-06-30	40	f
121	An ninh mang	NXB An ninh	Cac ky thuat bao mat he thong	2023-11-25	20	110000.00	165000.00	18	978-1234567964	Le Thi NNN	2023-08-05	40	f
122	Tat den	NXB Van hoc	Tieu thuyet kinh dien Viet Nam	2023-01-15	35	65000.00	97500.00	16	978-1234567965	Ngo Tat To	1939-01-01	41	f
123	So do	NXB Van hoc	Tieu thuyet phan anh xa hoi	2023-02-20	30	70000.00	105000.00	17	978-1234567966	Vu Trong Phung	1936-01-01	41	f
124	Chi Pheo	NXB Van hoc	Truyen ngan noi tieng	2023-03-25	40	55000.00	82500.00	15	978-1234567967	Nam Cao	1941-01-01	41	f
125	Vo nhat	NXB Van hoc	Tieu thuyet ve nong thon Viet Nam	2023-05-01	25	75000.00	112500.00	16	978-1234567968	Kim Lan	1962-01-01	41	f
126	Dat rung phuong Nam	NXB Van hoc	Tieu thuyet dac sac mien Nam	2023-06-05	45	80000.00	120000.00	15	978-1234567969	Doan Gioi	1957-01-01	41	f
127	Nha gia kim	NXB Van hoc	Tieu thuyet hien dai Viet Nam	2023-07-10	20	85000.00	127500.00	17	978-1234567970	Nguyen Nhat Anh	2005-01-01	41	f
128	Canh dong bat tan	NXB Van hoc	Truyen ngan dac sac	2023-08-15	30	60000.00	90000.00	16	978-1234567971	Nguyen Ngoc Tu	2005-01-01	41	f
129	Tho Xuan Dieu	NXB Van hoc	Tuyen tap tho Xuan Dieu	2023-09-20	25	70000.00	105000.00	15	978-1234567972	Xuan Dieu	1990-01-01	41	f
130	Truyen Kieu	NXB Van hoc	Tac pham kinh dien dan toc	2023-10-25	50	50000.00	75000.00	14	978-1234567973	Nguyen Du	1820-01-01	41	f
131	Vo chong A Phu	NXB Van hoc	Truyen ngan noi tieng	2023-11-30	35	65000.00	97500.00	16	978-1234567974	To Hoai	1952-01-01	41	f
132	Hai dua tre	NXB Van hoc	Truyen ngan cam dong	2024-01-05	40	55000.00	82500.00	15	978-1234567975	Thach Lam	1941-01-01	41	f
133	Ben kia bo ao vong	NXB Van hoc	Tieu thuyet hien dai	2024-02-10	20	90000.00	135000.00	17	978-1234567976	Duong Thu Huong	2002-01-01	41	f
134	Tho Huy Can	NXB Van hoc	Tuyen tap tho Huy Can	2024-03-15	18	75000.00	112500.00	16	978-1234567977	Huy Can	1995-01-01	41	f
135	Nhung ngay tho au	NXB Van hoc	Hoi ky van hoc	2024-04-20	22	80000.00	120000.00	16	978-1234567978	Nguyen Hong	1938-01-01	41	f
136	Dong song thoi gian	NXB Van hoc	Tieu thuyet hien dai	2024-05-25	15	95000.00	142500.00	18	978-1234567979	Nguyen Viet Ha	2010-01-01	41	f
137	Nha gia kim	NXB Van hoc	Tieu thuyet noi tieng the gioi	2023-01-20	40	80000.00	120000.00	16	978-1234567980	Paulo Coelho	1988-01-01	42	f
138	Cha giau cha ngheo	NXB Van hoc	Sach ve tu duy tai chinh	2023-02-25	45	75000.00	112500.00	15	978-1234567981	Robert Kiyosaki	1997-01-01	42	f
139	Hai so phan	NXB Van hoc	Tieu thuyet kinh dien Nga	2023-04-02	30	90000.00	135000.00	17	978-1234567982	Dostoevsky	1866-01-01	42	f
140	Tram nam co don	NXB Van hoc	Tieu thuyet Nobel van hoc	2023-05-08	25	85000.00	127500.00	18	978-1234567983	Gabriel Garcia Marquez	1967-01-01	42	f
141	Nguoi trong bong toi	NXB Van hoc	Tieu thuyet trinh tham	2023-06-14	35	70000.00	105000.00	16	978-1234567984	Keigo Higashino	2010-01-01	42	f
142	Chiec o to muc	NXB Van hoc	Tieu thuyet hai huoc	2023-07-20	40	65000.00	97500.00	15	978-1234567985	Jerome K. Jerome	1889-01-01	42	f
143	Tinh yeu thoi thanh xuan	NXB Van hoc	Tieu thuyet tinh cam	2023-08-26	30	75000.00	112500.00	16	978-1234567986	Ichikawa Takuji	2005-01-01	42	f
144	Dac nhan tam	NXB Van hoc	Sach ky nang giao tiep	2023-10-02	50	60000.00	90000.00	15	978-1234567987	Dale Carnegie	1936-01-01	42	f
145	Hoang tu be	NXB Van hoc	Tac pham van hoc kinh dien	2023-11-08	60	50000.00	75000.00	12	978-1234567988	Antoine de Saint-Exup‚ry	1943-01-01	42	f
146	Khong gia dinh	NXB Van hoc	Tieu thuyet Phap noi tieng	2023-12-14	35	80000.00	120000.00	14	978-1234567989	Hector Malot	1878-01-01	42	f
147	Tuyet	NXB Van hoc	Tieu thuyet Nh?t Ban	2024-01-20	25	90000.00	135000.00	17	978-1234567990	Yukio Mishima	1956-01-01	42	f
148	Cuon theo chieu gio	NXB Van hoc	Tieu thuyet tinh cam My	2024-02-26	30	85000.00	127500.00	16	978-1234567991	Margaret Mitchell	1936-01-01	42	f
149	Truyen thuyet thanh Giong	NXB Van hoc	Truyen co tich Han Quoc	2024-04-04	40	70000.00	105000.00	15	978-1234567992	Hong Kyung Ran	2000-01-01	42	f
150	Biet minh biet nguoi tram tran tram thang	NXB Van hoc	Sach chien luoc	2024-05-10	20	95000.00	142500.00	18	978-1234567993	Truong Nghia Manh	2005-01-01	42	f
151	Dem trong rung	NXB Van hoc	Tieu thuyet trinh tham	2024-06-16	15	100000.00	150000.00	17	978-1234567994	Agatha Christie	1939-01-01	42	f
152	Tam ly hoc dai cuong	NXB Khoa hoc	Co so tam ly hoc	2023-01-25	25	90000.00	135000.00	18	978-1234567995	Nguyen Van OOO	2020-01-01	43	f
153	Tu duy nhanh va cham	NXB Tri thuc	Phan tich hai he thong tu duy	2023-03-03	30	85000.00	127500.00	17	978-1234567996	Daniel Kahneman	2011-01-01	43	f
154	Tam ly hoc tich cuc	NXB Khoa hoc	Cach song tich cuc hon	2023-04-09	35	80000.00	120000.00	16	978-1234567997	Martin Seligman	2002-01-01	43	f
155	Suc manh cua thoi quen	NXB Tri thuc	Thay doi thoi quen thanh cong	2023-05-15	40	75000.00	112500.00	15	978-1234567998	Charles Duhigg	2012-01-01	43	f
156	Tam ly hoc hanh vi	NXB Khoa hoc	Nghien cuu hanh vi con nguoi	2023-06-21	20	95000.00	142500.00	18	978-1234567999	John B. Watson	1924-01-01	43	f
157	Tu te voi chinh minh	NXB Tam ly	Song hanh phuc hon	2023-07-27	45	70000.00	105000.00	16	978-1234568000	Kristin Neff	2011-01-01	43	f
158	Tam ly hoc phat trien	NXB Khoa hoc	Phat trien tuoi tho den truong thanh	2023-09-02	25	100000.00	150000.00	19	978-1234568001	Jean Piaget	1950-01-01	43	f
159	Nghi giau lam giau	NXB Tri thuc	Tu duy cua nguoi giau	2023-10-08	50	65000.00	97500.00	15	978-1234568002	Napoleon Hill	1937-01-01	43	f
160	Tam ly hoc giao tiep	NXB Khoa hoc	Ky nang giao tiep hieu qua	2023-11-14	30	85000.00	127500.00	17	978-1234568003	Le Thi PPP	2015-01-01	43	f
161	Doc vi bat ky ai	NXB Tri thuc	Hieu tam ly nguoi khac	2023-12-20	35	80000.00	120000.00	16	978-1234568004	David J. Lieberman	2007-01-01	43	f
162	7 thoi quen hieu qua	NXB Tri thuc	Xay dung thoi quen thanh cong	2023-01-30	40	85000.00	127500.00	16	978-1234568005	Stephen Covey	1989-01-01	44	f
163	Dac nhan tam	NXB Tri thuc	Nghe thuat giao tiep	2023-03-08	50	70000.00	105000.00	15	978-1234568006	Dale Carnegie	1936-01-01	44	f
164	Toi tai gioi ban cung the	NXB Tri thuc	Phat trien ban than	2023-04-14	45	75000.00	112500.00	16	978-1234568007	Adam Khoo	2003-01-01	44	f
165	Nguoi gioi khong phai hoc	NXB Tri thuc	Phuong phap hoc tap hieu qua	2023-05-20	35	80000.00	120000.00	17	978-1234568008	Alpha Books	2010-01-01	44	f
166	Ky nang lam viec nhom	NXB Ky nang	Hop tac hieu qua trong cong viec	2023-06-26	30	90000.00	135000.00	18	978-1234568009	John C. Maxwell	2002-01-01	44	f
167	Quan ly thoi gian	NXB Ky nang	Toi uu hoa thoi gian	2023-08-02	40	75000.00	112500.00	16	978-1234568010	Brian Tracy	2004-01-01	44	f
168	Noi truoc dam dong	NXB Ky nang	Ky nang thuyet trinh	2023-09-08	25	85000.00	127500.00	17	978-1234568011	Dale Carnegie	1956-01-01	44	f
169	Giai quyet xung dot	NXB Ky nang	Cach xu ly xung dot hieu qua	2023-10-14	20	95000.00	142500.00	18	978-1234568012	Kenneth Cloke	2011-01-01	44	f
170	Ky nang phong van	NXB Ky nang	Chuan bi phong van xin viec	2023-11-20	30	80000.00	120000.00	16	978-1234568013	Nguyen Van QQQ	2015-01-01	44	f
171	Tu lap thanh cong	NXB Ky nang	Song tu lap tuoi tre	2023-12-26	35	70000.00	105000.00	15	978-1234568014	Tran Thi RRR	2018-01-01	44	f
172	Sherlock Holmes	NXB Van hoc	Tuyen tap truyen trinh tham	2023-02-05	30	80000.00	120000.00	16	978-1234568015	Arthur Conan Doyle	1892-01-01	45	f
173	Bi an nha so 10	NXB Van hoc	Tieu thuyet trinh tham	2023-03-13	25	90000.00	135000.00	17	978-1234568016	Keigo Higashino	2011-01-01	45	f
174	Conan tap 1	NXB Kim Dong	Truyen tranh trinh tham	2023-04-19	50	50000.00	75000.00	12	978-1234568017	Aoyama Gosho	1994-01-01	45	f
175	Murder on the Orient Express	NXB Van hoc	Tieu thuyet trinh tham	2023-05-25	20	95000.00	142500.00	18	978-1234568018	Agatha Christie	1934-01-01	45	f
176	Bi mat trong phong kin	NXB Van hoc	Truyen trinh tham	2023-07-01	35	85000.00	127500.00	16	978-1234568019	John Dickson Carr	1935-01-01	45	f
177	Phu thuy lang Whitechapel	NXB Van hoc	Tieu thuyet trinh tham	2023-08-07	30	90000.00	135000.00	17	978-1234568020	Alex Grecian	2012-01-01	45	f
178	Nhung nguoi ban	NXB Van hoc	Truyen trinh tham	2023-09-13	25	80000.00	120000.00	16	978-1234568021	S. E. Lynes	2017-01-01	45	f
179	Giet chet con chim nhan	NXB Van hoc	Tieu thuyet trinh tham	2023-10-19	40	75000.00	112500.00	15	978-1234568022	Harper Lee	1960-01-01	45	f
180	Bi an nui Old	NXB Van hoc	Tieu thuyet trinh tham	2023-11-25	15	100000.00	150000.00	18	978-1234568023	Thomas Olde Heuvelt	2016-01-01	45	f
181	Nguoi dan ong trong mang nhen	NXB Van hoc	Truyen trinh tham	2024-01-01	20	95000.00	142500.00	17	978-1234568024	Stieg Larsson	2005-01-01	45	f
182	Bi mat tu duy trieu phu	NXB Tai chinh	Tu duy lam giau	2023-02-10	35	90000.00	135000.00	18	978-1234568025	T. Harv Eker	2005-01-01	46	f
183	Dac quyen gai	NXB Tai chinh	Sach ve kinh doanh	2023-03-18	30	95000.00	142500.00	17	978-1234568026	Robert Kiyosaki	2011-01-01	46	f
184	Khoi nghiep voi 100$	NXB Tai chinh	Huong dan khoi nghiep	2023-04-24	25	85000.00	127500.00	16	978-1234568027	Chris Guillebeau	2010-01-01	46	f
185	Quoc gia khoi nghiep	NXB Tai chinh	Cau chuyen Israel	2023-06-30	20	100000.00	150000.00	18	978-1234568028	Dan Senor	2009-01-01	46	f
186	Lean Startup	NXB Tai chinh	Khoi nghiep toi gian	2023-08-06	15	110000.00	165000.00	19	978-1234568029	Eric Ries	2011-01-01	46	f
187	Blue Ocean Strategy	NXB Tai chinh	Chien luoc dai duong xanh	2023-09-12	18	120000.00	180000.00	18	978-1234568030	W. Chan Kim	2005-01-01	46	f
188	4 gio lam viec mot tuan	NXB Tai chinh	Lam viec hieu qua	2023-10-18	22	95000.00	142500.00	17	978-1234568031	Timothy Ferriss	2007-01-01	46	f
189	Nha dau tu thong minh	NXB Tai chinh	Dau tu chung khoan	2023-11-24	25	105000.00	157500.00	18	978-1234568032	Benjamin Graham	1949-01-01	46	f
190	Banh keo lanh loi	NXB Tai chinh	Kinh doanh nho	2024-01-30	30	80000.00	120000.00	16	978-1234568033	Nguyen Van SSS	2015-01-01	46	f
191	Kinh doanh nhu Jack Ma	NXB Tai chinh	Bai hoc tu Alibaba	2024-03-08	20	90000.00	135000.00	17	978-1234568034	Liu Shiying	2017-01-01	46	f
192	Marketing 4.0	NXB Tai chinh	Chuyen doi so trong marketing	2023-02-15	25	95000.00	142500.00	18	978-1234568035	Philip Kotler	2016-01-01	47	f
193	22 quy luat bat bien trong marketing	NXB Tai chinh	Nguyen tac marketing	2023-03-23	30	90000.00	135000.00	17	978-1234568036	Al Ries	1993-01-01	47	f
194	Content hay nuot troi	NXB Tai chinh	Sang tao noi dung	2023-05-01	35	85000.00	127500.00	16	978-1234568037	Ann Handley	2014-01-01	47	f
195	Marketing nho gioi	NXB Tai chinh	Marketing cho doanh nghiep nho	2023-06-07	40	80000.00	120000.00	15	978-1234568038	Jay Conrad Levinson	1984-01-01	47	f
196	Suc manh cua viral marketing	NXB Tai chinh	Lan truyen thong diep	2023-07-13	20	100000.00	150000.00	18	978-1234568039	Seth Godin	2003-01-01	47	f
197	Nhung ke sang tao	NXB Tai chinh	Case study marketing	2023-08-19	25	95000.00	142500.00	17	978-1234568040	Adam Morgan	1999-01-01	47	f
198	Branding - Buoc chay danh thuong hieu	NXB Tai chinh	Xay dung thuong hieu	2023-09-25	15	110000.00	165000.00	19	978-1234568041	Marty Neumeier	2003-01-01	47	f
199	Digital marketing tu A den Z	NXB Tai chinh	Marketing so	2023-11-01	30	90000.00	135000.00	17	978-1234568042	Pham Van TTT	2018-01-01	47	f
200	Storybrand	NXB Tai chinh	Marketing bang cau chuyen	2023-12-07	35	85000.00	127500.00	16	978-1234568043	Donald Miller	2017-01-01	47	f
201	Nhin lai de di xa hon	NXB Tai chinh	Case study marketing Viet Nam	2024-01-13	25	95000.00	142500.00	17	978-1234568044	Nguyen Phi Van	2019-01-01	47	f
202	Lich su Viet Nam	NXB Lich su	Toan canh lich su Viet Nam	2023-02-20	40	90000.00	135000.00	16	978-1234568045	Tran Trong Kim	1920-01-01	48	f
203	Dai Viet su ky toan thu	NXB Lich su	Su ky Viet Nam	2023-03-28	30	120000.00	180000.00	18	978-1234568046	Ngo Si Lien	1479-01-01	48	f
204	Lich su the gioi	NXB Lich su	Tong quan lich su the gioi	2023-05-04	25	100000.00	150000.00	17	978-1234568047	H.G. Wells	1922-01-01	48	f
205	Nhung vi tuong lua danh	NXB Lich su	Tieu su cac tuong linh	2023-06-10	20	95000.00	142500.00	18	978-1234568048	Nguyen Van UUU	2015-01-01	48	f
206	Chien tranh va hoa binh	NXB Lich su	Tieu thuyet lich su	2023-07-16	15	110000.00	165000.00	19	978-1234568049	Leo Tolstoy	1869-01-01	48	f
207	Lich su Trung Quoc	NXB Lich su	Tong quan lich su Trung Quoc	2023-08-22	35	85000.00	127500.00	17	978-1234568050	Jonathan Clements	2008-01-01	48	f
208	Nhung ngay cuoi cua chien tranh	NXB Lich su	Ho so giai mat	2023-09-28	30	90000.00	135000.00	18	978-1234568051	Larry Berman	1982-01-01	48	f
209	Lich su tu tuong	NXB Lich su	Dong tu tuong the gioi	2023-11-04	25	100000.00	150000.00	19	978-1234568052	Bertrand Russell	1945-01-01	48	f
210	Ho Chi Minh - mot cuoc doi	NXB Lich su	Tieu su Bac Ho	2023-12-10	40	80000.00	120000.00	16	978-1234568053	William J. Duiker	2000-01-01	48	f
211	Lich su Dong Nam A	NXB Lich su	Tong quan khu vuc	2024-01-16	20	95000.00	142500.00	17	978-1234568054	Arthur Cotterell	2014-01-01	48	f
212	Nha gia kim triet hoc	NXB Tri thuc	Triet ly cuoc song	2023-02-25	25	90000.00	135000.00	18	978-1234568055	Paulo Coelho	1988-01-01	49	f
213	Triet hoc cho nguoi moi bat dau	NXB Tri thuc	Gioi thieu triet hoc	2023-04-03	30	85000.00	127500.00	17	978-1234568056	R.L. Stevenson	2010-01-01	49	f
214	Su im lang cua bay cuu	NXB Tri thuc	Triet ly ton giao	2023-05-09	20	95000.00	142500.00	19	978-1234568057	Thomas Merton	1949-01-01	49	f
215	Triet hoc Dong Tay	NXB Tri thuc	So sanh triet ly	2023-06-15	15	100000.00	150000.00	18	978-1234568058	F.S.C. Northrop	1946-01-01	49	f
216	Y thuc he Duc	NXB Tri thuc	Triet hoc Marx	2023-07-21	18	110000.00	165000.00	19	978-1234568059	Karl Marx	1845-01-01	49	f
217	Toan cao cap	NXB Giao duc	Giao trinh toan dai hoc	2023-03-05	30	95000.00	142500.00	18	978-1234568060	Nguyen Van VVV	2015-01-01	50	f
218	Giai tich 1	NXB Giao duc	Giao trinh giai tich	2023-04-11	25	90000.00	135000.00	17	978-1234568061	Tran Thi WWW	2016-01-01	50	f
219	Dai so tuyen tinh	NXB Giao duc	Ly thuyet va bai tap	2023-05-17	20	100000.00	150000.00	18	978-1234568062	Le Van XXX	2017-01-01	50	f
220	Toan roi rac	NXB Giao duc	Co so toan roi rac	2023-06-23	15	110000.00	165000.00	19	978-1234568063	Pham Thi YYY	2018-01-01	50	f
221	Xac suat thong ke	NXB Giao duc	Ung dung xac suat	2023-07-29	18	105000.00	157500.00	18	978-1234568064	Hoang Van ZZZ	2019-01-01	50	f
222	Vat ly dai cuong	NXB Khoa hoc	Co so vat ly	2023-03-10	25	95000.00	142500.00	18	978-1234568065	Nguyen Van AAAA	2015-01-01	51	f
223	Co hoc luu chat	NXB Khoa hoc	Ly thuyet co hoc	2023-04-16	20	100000.00	150000.00	19	978-1234568066	Tran Thi BBBB	2016-01-01	51	f
224	Dien tu hoc	NXB Khoa hoc	Nguyen ly dien tu	2023-05-22	15	110000.00	165000.00	18	978-1234568067	Le Van CCCC	2017-01-01	51	f
225	Quang hoc	NXB Khoa hoc	Ly thuyet anh sang	2023-06-28	18	105000.00	157500.00	17	978-1234568068	Pham Thi DDDD	2018-01-01	51	f
226	Vat ly hat nhan	NXB Khoa hoc	Co ban hat nhan	2023-08-04	12	120000.00	180000.00	19	978-1234568069	Hoang Van EEEE	2019-01-01	51	f
227	Hoa hoc dai cuong	NXB Khoa hoc	Co so hoa hoc	2023-03-15	30	90000.00	135000.00	17	978-1234568070	Nguyen Van FFFF	2015-01-01	52	f
228	Hoa hoc huu co	NXB Khoa hoc	Ly thuyet huu co	2023-04-21	25	95000.00	142500.00	18	978-1234568071	Tran Thi GGGG	2016-01-01	52	f
229	Hoa vo co	NXB Khoa hoc	Hop chat vo co	2023-05-27	20	100000.00	150000.00	17	978-1234568072	Le Van HHHH	2017-01-01	52	f
230	Hoa phan tich	NXB Khoa hoc	Phuong phap phan tich	2023-07-03	15	110000.00	165000.00	18	978-1234568073	Pham Thi IIII	2018-01-01	52	f
231	Hoa sinh hoc	NXB Khoa hoc	Ung dung hoa hoc	2023-08-09	18	105000.00	157500.00	19	978-1234568074	Hoang Van JJJJ	2019-01-01	52	f
232	Sinh hoc dai cuong	NXB Khoa hoc	Co so sinh hoc	2023-03-20	25	95000.00	142500.00	17	978-1234568075	Nguyen Van KKKK	2015-01-01	53	f
233	Sinh hoc te bao	NXB Khoa hoc	Cau truc te bao	2023-04-26	20	100000.00	150000.00	18	978-1234568076	Tran Thi LLLL	2016-01-01	53	f
234	Di truyen hoc	NXB Khoa hoc	Co che di truyen	2023-06-01	15	110000.00	165000.00	19	978-1234568077	Le Van MMMM	2017-01-01	53	f
235	Sinh thai hoc	NXB Khoa hoc	He sinh thai	2023-07-07	18	105000.00	157500.00	18	978-1234568078	Pham Thi NNNN	2018-01-01	53	f
236	Tien hoa	NXB Khoa hoc	Thuyet tien hoa	2023-08-13	12	120000.00	180000.00	17	978-1234568079	Hoang Van OOOO	2019-01-01	53	f
237	Tieng Anh co ban	NXB Ngoai ngu	Hoc tieng Anh tu dau	2023-03-25	50	60000.00	90000.00	12	978-1234568080	Nguyen Van PPPP	2015-01-01	54	f
238	Ngu phap tieng Anh	NXB Ngoai ngu	Day du ngu phap	2023-05-03	45	65000.00	97500.00	13	978-1234568081	Tran Thi QQQQ	2016-01-01	54	f
239	Tu vung tieng Anh	NXB Ngoai ngu	3000 tu thong dung	2023-06-09	40	70000.00	105000.00	14	978-1234568082	Le Van RRRR	2017-01-01	54	f
240	Luyen nghe tieng Anh	NXB Ngoai ngu	Ky nang nghe hieu	2023-07-15	35	75000.00	112500.00	15	978-1234568083	Pham Thi SSSS	2018-01-01	54	f
241	Tieng Anh giao tiep	NXB Ngoai ngu	Hoi thoai hang ngay	2023-08-21	30	80000.00	120000.00	16	978-1234568084	Hoang Van TTTT	2019-01-01	54	f
242	Tieng Nhat co ban	NXB Ngoai ngu	Hoc tieng Nhat N5	2023-09-27	25	85000.00	127500.00	17	978-1234568085	Nguyen Thi UUUU	2015-01-01	54	f
243	Tieng Han so cap	NXB Ngoai ngu	Hoc tieng Han co ban	2023-11-03	20	90000.00	135000.00	18	978-1234568086	Tran Van VVVV	2016-01-01	54	f
244	Tieng Phap cho nguoi moi	NXB Ngoai ngu	Bat dau voi tieng Phap	2023-12-09	15	95000.00	142500.00	19	978-1234568087	Le Thi WWWW	2017-01-01	54	f
245	Tieng Trung giao tiep	NXB Ngoai ngu	Hoi thoai hang ngay	2024-01-15	30	80000.00	120000.00	16	978-1234568088	Pham Van XXXX	2018-01-01	54	f
246	Tieng Duc co ban	NXB Ngoai ngu	Hoc tieng Duc A1	2024-02-21	25	85000.00	127500.00	17	978-1234568089	Hoang Thi YYYY	2019-01-01	54	f
247	Mon ngon Viet Nam	NXB Am thuc	100 mon an Viet	2023-03-30	40	70000.00	105000.00	15	978-1234568090	Nguyen Van ZZZZ	2015-01-01	55	f
248	Am thuc mien Bac	NXB Am thuc	Dac san mien Bac	2023-05-08	35	75000.00	112500.00	16	978-1234568091	Tran Thi AAAAA	2016-01-01	55	f
249	Am thuc mien Trung	NXB Am thuc	Dac san mien Trung	2023-06-14	30	80000.00	120000.00	17	978-1234568092	Le Van BBBBB	2017-01-01	55	f
250	Am thuc mien Nam	NXB Am thuc	Dac san mien Nam	2023-07-20	25	85000.00	127500.00	18	978-1234568093	Pham Thi CCCCC	2018-01-01	55	f
251	Mon ngon the gioi	NXB Am thuc	100 mon an quoc te	2023-08-26	20	90000.00	135000.00	19	978-1234568094	Hoang Van DDDDD	2019-01-01	55	f
252	Lam banh ngot	NXB Am thuc	50 cong thuc banh	2023-10-02	35	80000.00	120000.00	16	978-1234568095	Nguyen Thi EEEEE	2015-01-01	55	f
253	Pha che do uong	NXB Am thuc	Cocktail va sinh to	2023-11-08	30	85000.00	127500.00	17	978-1234568096	Tran Van FFFFF	2016-01-01	55	f
254	An chay	NXB Am thuc	Mon chay ngon	2023-12-14	25	90000.00	135000.00	18	978-1234568097	Le Thi GGGGG	2017-01-01	55	f
255	Book A	ABC Distributor	\N	\N	100	50.00	75.00	0	\N	\N	\N	1	f
256	Book A	ABC Distributor	A great book	2025-06-24	100	50.00	75.00	10	123-456-789	John Doe	2023-01-15	1	f
257	Book A	ABC Distributor	A great book	2025-06-24	100	50.00	75.00	10	123-456-789	John Doe	2023-01-15	1	t
258	Book A	ABC Distributor	A great book	2025-06-24	100	50.00	75.00	10	123-456-789	John Doe	2023-01-15	1	t
\.


--
-- Data for Name: voucher; Type: TABLE DATA; Schema: public; Owner: avnadmin
--

COPY public.voucher (voucherid, code, discount, duration, remaining) FROM stdin;
34	abc	10.00	2025-05-23	10
35	DatabaseN5	20.00	2025-05-31	10
36	12345	40.00	2025-05-23	10
37	nhom5	20.00	2025-05-30	10
38	codemoi	20.00	2025-07-07	-1
40	codetest	20.00	2025-07-06	-1
41	new_voucher	60000.00	2025-07-04	10
39	hung	10.00	2025-07-07	46
42	test	20000.00	2025-07-12	20
\.


--
-- Name: admin_adminid_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.admin_adminid_seq', 39, true);


--
-- Name: cartitem_cartitemid_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.cartitem_cartitemid_seq', 56, true);


--
-- Name: category_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.category_categoryid_seq', 58, true);


--
-- Name: customer_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.customer_customerid_seq', 57, true);


--
-- Name: orderline_orderlineid_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.orderline_orderlineid_seq', 80, true);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 65, true);


--
-- Name: product_productid_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.product_productid_seq', 258, true);


--
-- Name: voucher_voucherid_seq; Type: SEQUENCE SET; Schema: public; Owner: avnadmin
--

SELECT pg_catalog.setval('public.voucher_voucherid_seq', 42, true);


--
-- Name: admin admin_adminusername_key; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_adminusername_key UNIQUE (adminusername);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (adminid);


--
-- Name: cartitem cartitem_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.cartitem
    ADD CONSTRAINT cartitem_pkey PRIMARY KEY (cartitemid);


--
-- Name: category category_categoryname_key; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_categoryname_key UNIQUE (categoryname);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (categoryid);


--
-- Name: customer customer_customerusername_key; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_customerusername_key UNIQUE (customerusername);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customerid);


--
-- Name: orderline orderline_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.orderline
    ADD CONSTRAINT orderline_pkey PRIMARY KEY (orderlineid);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (productid);


--
-- Name: voucher voucher_code_key; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_code_key UNIQUE (code);


--
-- Name: voucher voucher_pkey; Type: CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pkey PRIMARY KEY (voucherid);


--
-- Name: idx_product_categoryid; Type: INDEX; Schema: public; Owner: avnadmin
--

CREATE INDEX idx_product_categoryid ON public.product USING btree (categoryid);


--
-- Name: all_vouchers delete_on_all_vouchers; Type: TRIGGER; Schema: public; Owner: avnadmin
--

CREATE TRIGGER delete_on_all_vouchers INSTEAD OF DELETE ON public.all_vouchers FOR EACH ROW EXECUTE FUNCTION public.trg_delete_all_vouchers();


--
-- Name: all_vouchers insert_on_all_vouchers; Type: TRIGGER; Schema: public; Owner: avnadmin
--

CREATE TRIGGER insert_on_all_vouchers INSTEAD OF INSERT ON public.all_vouchers FOR EACH ROW EXECUTE FUNCTION public.trg_insert_all_vouchers();


--
-- Name: orderline trigger_calculate_order_total; Type: TRIGGER; Schema: public; Owner: avnadmin
--

CREATE TRIGGER trigger_calculate_order_total AFTER INSERT OR DELETE OR UPDATE ON public.orderline FOR EACH ROW EXECUTE FUNCTION public.calculate_order_total();


--
-- Name: orders trigger_decrease_voucher_quantity; Type: TRIGGER; Schema: public; Owner: avnadmin
--

CREATE TRIGGER trigger_decrease_voucher_quantity AFTER INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.decrease_voucher_quantity();


--
-- Name: orderline trigger_update_product_quantity; Type: TRIGGER; Schema: public; Owner: avnadmin
--

CREATE TRIGGER trigger_update_product_quantity AFTER INSERT ON public.orderline FOR EACH ROW EXECUTE FUNCTION public.update_product_quantity();


--
-- Name: all_vouchers update_on_all_vouchers; Type: TRIGGER; Schema: public; Owner: avnadmin
--

CREATE TRIGGER update_on_all_vouchers INSTEAD OF UPDATE ON public.all_vouchers FOR EACH ROW EXECUTE FUNCTION public.trg_update_all_vouchers();


--
-- Name: orders update_totalspent_on_orders; Type: TRIGGER; Schema: public; Owner: avnadmin
--

CREATE TRIGGER update_totalspent_on_orders AFTER UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.trg_update_customer_totalspent();


--
-- Name: cartitem cartitem_customerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.cartitem
    ADD CONSTRAINT cartitem_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customer(customerid);


--
-- Name: cartitem cartitem_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.cartitem
    ADD CONSTRAINT cartitem_productid_fkey FOREIGN KEY (productid) REFERENCES public.product(productid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product fk_product_category; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_category FOREIGN KEY (categoryid) REFERENCES public.category(categoryid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: orderline orderline_orderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.orderline
    ADD CONSTRAINT orderline_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orders(orderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orderline orderline_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.orderline
    ADD CONSTRAINT orderline_productid_fkey FOREIGN KEY (productid) REFERENCES public.product(productid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_customerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customer(customerid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders voucherid_orders_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avnadmin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT voucherid_orders_fkey FOREIGN KEY (voucherid) REFERENCES public.voucher(voucherid);


--
-- PostgreSQL database dump complete
--

