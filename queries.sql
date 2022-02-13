CREATE DATABASE lab_dbms_assignment_solution;

USE lab_dbms_assignment_solution;

# 1. Creating tables

CREATE TABLE supplier (
    supp_id INT PRIMARY KEY AUTO_INCREMENT,
    supp_name VARCHAR(250),
    supp_city VARCHAR(100),
    supp_phone VARCHAR(25)
);

CREATE TABLE customer (
    cus_id INT PRIMARY KEY AUTO_INCREMENT,
    cus_name VARCHAR(250),
    cus_phone VARCHAR(25),
    cus_city VARCHAR(100),
    cus_gender CHAR(1)
);

CREATE TABLE category (
    cat_id INT PRIMARY KEY AUTO_INCREMENT,
    cat_name VARCHAR(250)
);

CREATE TABLE product (
    pro_id INT PRIMARY KEY AUTO_INCREMENT,
    pro_name VARCHAR(250),
    pro_desc TINYTEXT,
    cat_id INT,
    FOREIGN KEY (cat_id)
        REFERENCES category (cat_id)
);

CREATE TABLE product_details (
    prod_id INT PRIMARY KEY AUTO_INCREMENT,
    pro_id INT,
    supp_id INT,
    price INT,
    FOREIGN KEY (pro_id)
        REFERENCES product (pro_id),
    FOREIGN KEY (supp_id)
        REFERENCES supplier (supp_id)
);

CREATE TABLE orders (
    ord_id INT PRIMARY KEY,
    ord_amount INT,
    ord_date DATE,
    cus_id INT,
    prod_id INT,
    FOREIGN KEY (cus_id)
        REFERENCES customer (cus_id),
    FOREIGN KEY (prod_id)
        REFERENCES product_details (prod_id)
);

CREATE TABLE rating (
    rat_id INT PRIMARY KEY AUTO_INCREMENT,
    cus_id INT,
    supp_id INT,
    rat_ratstars INT,
    FOREIGN KEY (cus_id)
        REFERENCES customer (cus_id),
    FOREIGN KEY (supp_id)
        REFERENCES supplier (supp_id)
);

# 2. Inserting values

INSERT INTO supplier (supp_name, supp_city, supp_phone) VALUES
	('Rajesh Retails', 'Delhi', '1234567890'),
    ('Appario Ltd.', 'Mumbai', '2589631470'),
    ('Knome products', 'Banglore', '9785462315'),
    ('Bansal Retails', 'Kochi', '8975463285'),
    ('Mittal Ltd.', 'Lucknow', '7898456532');

INSERT INTO customer (cus_name, cus_phone, cus_city, cus_gender) VALUES
	('AAKASH', '9999999999', 'DELHI', 'M'),
    ('AMAN', '9785463215', 'NOIDA', 'M'),
    ('NEHA', '9999999999', 'MUMBAI', 'F'),
    ('MEGHA', '9994562399', 'KOLKATA', 'F'),
    ('PULKIT', '7895999999', 'LUCKNOW', 'M');

INSERT INTO category (cat_name) VALUES
	('BOOKS'),
    ('GAMES'),
    ('GROCERIES'),
    ('ELECTRONICS'),
    ('CLOTHES');

INSERT INTO product (pro_name, pro_desc, cat_id) VALUES
	('GTA V', 'DFJDJFDJFDJFDJFJF', 2),
    ('TSHIRT', 'DFDFJDFJDKFD', 5),
    ('ROG LAPTOP', 'DFNTTNTNTERND', 4),
    ('OATS', 'REURENTBTOTH', 3),
    ('HARRY POTTER', 'NBEMCTHTJTH', 1);

INSERT INTO product_details (pro_id, supp_id, price) VALUES
	(1, 2, 1500),
    (3, 5, 30000),
    (5, 1, 3000),
    (2, 3, 2500),
    (4, 1, 1000);

INSERT INTO orders ( ord_id, ord_amount, ord_date, cus_id, prod_id) VALUES
	(20, 1500, '2021-10-12', 3, 5),
    (25, 30500, '2021-09-16', 5, 2),
    (26, 2000, '2021-10-05', 1, 1),
    (30, 3500, '2021-08-16', 4, 3),
    (50, 2000, '2021-10-06', 2, 1);

INSERT INTO rating (cus_id, supp_id, rat_ratstars) VALUES
	(2, 2, 4),
    (3, 4, 3),
    (5, 1, 5),
    (1, 3, 2),
    (4, 5, 4);

# 3. Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000

SELECT 
    cus_gender, COUNT(cus_gender) count
FROM
    customer,
    orders
WHERE
    customer.cus_id = orders.cus_id
        AND orders.ord_amount >= 3000
GROUP BY cus_gender;

/*
	OUTPUT
    cus_gender  count
    M			1
	F			1
*/

# 4. Display all the orders along with the product name ordered by a customer having Customer_Id=2

SELECT 
    orders.*, product.pro_name
FROM
    orders,
    product_details,
    product
WHERE
    orders.prod_id = product_details.prod_id
        AND product_details.pro_id = product.pro_id
        AND orders.cus_id = 2;

/*
	OUTPUT
    ord_id  ord_amount  ord_date 	cus_id  prod_id pro_name
    50		2000		2021-10-06	2		1		GTA V
*/

# 5. Display the Supplier details who can supply more than one product

SELECT 
    supplier.*
FROM
    supplier,
    product_details
WHERE
    supplier.supp_id = product_details.supp_id
GROUP BY supplier.supp_id
HAVING COUNT(supplier.supp_id) > 1;

/*
	OUTPUT
    supp_id supp_name 		supp_city supp_phone
    1		Rajesh Retails	Delhi	  1234567890
*/

# 6. Find the category of the product whose order amount is minimum

SELECT 
    category.*
FROM
    orders,
    product_details,
    product,
    category
WHERE
    orders.prod_id = product_details.prod_id
        AND product_details.pro_id = product.pro_id
        AND product.cat_id = category.cat_id
        AND orders.ord_amount = (SELECT 
            MIN(ord_amount)
        FROM
            orders);

/*
	OUTPUT
    cat_id  cat_name
    3		GROCERIES
*/

# 7. Display the Id and Name of the Product ordered after “2021-10-05”

SELECT 
    product.pro_id, product.pro_name
FROM
    orders,
    product_details,
    product
WHERE
    orders.prod_id = product_details.prod_id
        AND product_details.pro_id = product.pro_id
        AND orders.ord_date > '2021-10-05';

/*
	OUTPUT
    pro_id  pro_name
    4		OATS
	1		GTA V
*/

# 8. Display customer name and gender whose names start or end with character 'A'

SELECT 
    customer.cus_name, customer.cus_gender
FROM
    customer
WHERE
    cus_name LIKE 'A%' OR cus_name LIKE '%A';

/*
	OUTPUT
    cus_name cus_gender
    AAKASH	 M
	AMAN	 M
	NEHA	 F
	MEGHA	 F
*/

# 9. Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”

DELIMITER $$
CREATE PROCEDURE `supplier_rating` ()
BEGIN
	SELECT 
		supplier.supp_id,
        supplier.supp_name,
		rating.rat_ratstars,
		CASE
			WHEN rating.rat_ratstars > 4 THEN 'Genuine Supplier'
			WHEN rating.rat_ratstars > 2 THEN 'Average Supplier'
			ELSE 'Supplier should not be considered'
		END verdict
	FROM
		supplier,
		rating
	WHERE
		supplier.supp_id = rating.supp_id;
END$$
DELIMITER ;

CALL supplier_rating();

/*
	OUTPUT
    supp_id supp_name 		rat_ratstars verdict
    1		Rajesh Retails	5			 Genuine Supplier
	2		Appario Ltd.	4			 Average Supplier
	3		Knome products	2			 Supplier should not be considered
	4		Bansal Retails	3			 Average Supplier
	5		Mittal Ltd.		4			 Average Supplier
*/