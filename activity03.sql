CREATE DATABASE InventoryManagementes ; 
USE InventoryManagementes ;

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Stock_Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Sale_Date DATE
);

CREATE TABLE Sale_Details (
    Sale_ID INT,
    Product_ID INT,
    Quantity INT,
    PRIMARY KEY (Sale_ID, Product_ID),
    FOREIGN KEY (Sale_ID) REFERENCES Sales(Sale_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

DELIMITER //
CREATE TRIGGER before_sale_details_insert
BEFORE INSERT ON Sale_Details
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;

    IF NEW.Quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    SELECT Stock_Quantity
    INTO available_stock
    FROM Product
    WHERE Product_ID = NEW.Product_ID
    FOR UPDATE;

    IF NEW.Quantity > available_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;
END//

CREATE TRIGGER after_sale_details_insert
AFTER INSERT ON Sale_Details
FOR EACH ROW
BEGIN
    UPDATE Product
    SET Stock_Quantity = Stock_Quantity - NEW.Quantity
    WHERE Product_ID = NEW.Product_ID;
END//
DELIMITER ;

INSERT INTO Product
VALUES (1, 'Laptop', 10, 50000.00);

INSERT INTO Sales VALUES
(101, '2026-10-16'),
(102, '2026-10-16'),
(103, '2026-10-16');
INSERT INTO Sale_Details
VALUES (101, 1, 3);

SELECT * FROM Product;
INSERT INTO Sale_Details
VALUES (102, 1, 8);
INSERT INTO Sale_Details
VALUES (103, 1, 0);
SELECT * FROM Product;






