-- Bảng thể loại sản phẩm
CREATE TABLE category (
    categoryid BIGINT PRIMARY KEY,
    categoryname VARCHAR(255)
);

-- Bảng sản phẩm
CREATE TABLE product (
    productid BIGINT PRIMARY KEY ,
    name VARCHAR(255),
    quantity INTEGER,
    importprice DOUBLE PRECISION,
    sellprice DOUBLE PRECISION,
    image VARCHAR(255),
    tax DOUBLE PRECISION,
    status VARCHAR(50),
    description TEXT,
    categoryid BIGINT,
    FOREIGN KEY (categoryid) REFERENCES category(categoryid)
);

-- Bảng giỏ hàng
CREATE TABLE cart (
    cartid BIGINT PRIMARY KEY ,
    customerid BIGINT UNIQUE -- mỗi khách hàng có 1 giỏ
);

-- Bảng khách hàng
CREATE TABLE customer (
    customerid BIGINT PRIMARY KEY,
    username VARCHAR(255),
    password VARCHAR(255),
    customername VARCHAR(255),
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    gender VARCHAR(10),
    cardnumber VARCHAR(20),
    phone VARCHAR(20),
    email VARCHAR(255),
    address VARCHAR(255),
    cartid BIGINT UNIQUE,
    FOREIGN KEY (cartid) REFERENCES cart(cartid)
);

-- Bảng admin
CREATE TABLE admin (
    adminid BIGINT PRIMARY KEY,
    adminname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    gender VARCHAR(10)
);

-- Bảng đơn hàng
CREATE TABLE orders (
    orderid BIGINT PRIMARY KEY,
    orderdate TIMESTAMP,
    taxvat DOUBLE PRECISION,
    netamount DOUBLE PRECISION,
    totalamount DOUBLE PRECISION,
    storestaffid BIGINT,
    customerid BIGINT,
    FOREIGN KEY (customerid) REFERENCES customer(customerid)
);

-- Bảng dòng đơn hàng
CREATE TABLE orderlines (
    orderlineid BIGINT PRIMARY KEY,
    productid BIGINT,
    orderid BIGINT,
    quantity INTEGER,
    FOREIGN KEY (productid) REFERENCES product(productid),
    FOREIGN KEY (orderid) REFERENCES orders(orderid)
);

-- Bảng sách (kế thừa hoặc độc lập)
CREATE TABLE book (
    productid BIGINT PRIMARY KEY,
    author VARCHAR(100),
    publisher VARCHAR(100),
    FOREIGN KEY (productid) REFERENCES product(productid) ON DELETE CASCADE
);


-- Inventory tạm thời giữ trống hoặc bạn có thể dùng bảng phụ

CREATE TABLE inventory (
    productid BIGINT REFERENCES product(productid),
    quantity INT,
    PRIMARY KEY(productid)
);


CREATE TABLE cart_items (
    cartid BIGINT,
    productid BIGINT,
    quantity INTEGER DEFAULT 1,
    PRIMARY KEY (cartid, productid),
    FOREIGN KEY (cartid) REFERENCES cart(cartid) ON DELETE CASCADE,
    FOREIGN KEY (productid) REFERENCES product(productid)
);
CREATE TABLE inventory_items (
    inventoryid BIGINT,
    productid BIGINT,
    quantity INTEGER DEFAULT 0,
    PRIMARY KEY (inventoryid, productid),
    FOREIGN KEY (inventoryid) REFERENCES inventory(inventoryid) ON DELETE CASCADE,
    FOREIGN KEY (productid) REFERENCES product(productid)
);

CREATE TABLE storestaff (
    storestaffid BIGSERIAL PRIMARY KEY,
    staffname VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    gender VARCHAR(10)
);

INSERT INTO category (categoryid, categoryname) VALUES 
(1, 'Books'),
(2, 'Electronics'),
(3, 'Clothing');

INSERT INTO product (productid, name, quantity, importprice, sellprice, image, tax, status, description, categoryid) VALUES 
(1, 'Java Programming', 50, 10.0, 15.0, 'java.jpg', 0.1, 'Available', 'Learn Java from scratch', 1),
(2, 'Smartphone XYZ', 30, 200.0, 250.0, 'phone.jpg', 0.15, 'Available', 'Latest smartphone', 2);

INSERT INTO book (productid, author, publisher) VALUES 
(1, 'James Gosling', 'Sun Microsystems');

INSERT INTO customer (customerid, username, password, customername, firstname, lastname, gender, cardnumber, phone, email, address) VALUES 
(1, 'johndoe', 'password123', 'John Doe', 'John', 'Doe', 'Male', '1234-5678-9012-3456', '0909999999', 'john@example.com', '123 Street');

INSERT INTO cart (cartid, customerid) VALUES (1,1);

INSERT INTO admin (adminid, adminname, email, phone, gender) VALUES 
(1, 'Admin One', 'admin@example.com', '0911111111', 'Female');

INSERT INTO storestaff (staffname, email, phone, gender) VALUES 
('Alice Staff', 'alice@store.com', '0900000000', 'Female');

INSERT INTO orders (orderid, orderdate, taxvat, netamount, totalamount, storestaffid, customerid) VALUES 
(1, current_date, 1.5, 13.5, 15.0, 1, 1);

INSERT INTO orderlines (orderlineid, productid, orderid, quantity) VALUES 
(1, 1, 1, 2),
(2, 2, 1, 1);
INSERT INTO inventory (productid, quantity) VALUES 
(1, 100),
(2, 50);
