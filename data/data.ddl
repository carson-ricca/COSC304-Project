USE d86z63czwh261eo

DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS productinventory;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS orderproduct;
DROP TABLE IF EXISTS incart;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS ordersummary;
DROP TABLE IF EXISTS paymentmethod;
DROP TABLE IF EXISTS customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    shipped             BIT DEFAULT 'false',
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),
    enteredName         VARCHAR(100),
    enteredEmail        VARCHAR(100)
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Flower');
INSERT INTO category(categoryName) VALUES ('Pre-Rolls');
INSERT INTO category(categoryName) VALUES ('Seeds');
INSERT INTO category(categoryName) VALUES ('Baked Goods and Snacks');
INSERT INTO category(categoryName) VALUES ('Beverages');
INSERT INTO category(categoryName) VALUES ('Oils and Capsules');
INSERT INTO category(categoryName) VALUES ('Chews and Candy');

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Tangerine Dream', 1, 'This THC-dominant sativa is typically derived from G13 and Neville’s A5 Haze. The deep purple bud, has a strong citrusy aroma.',26.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Pink Kush',1,'Pink Kush is a high-THC indica flower linked to OG Kush. With a recognizable dense, dark green bud striped and deep purple hues, this bud has a fresh lemony aroma with notes of spice and lavender.',31.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('THC Hybrid',1,'This premium flower is a beautiful light green with contrasting deep orange hairs, and they carry a heavy dusting of THC crystals. This strain combines aromas that are both earthly and sweet with flavours of nectarine, pepper, and honey cream.',20.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Blue Dream Pre-Roll',2,'Blue Dream is a high-THC, sativa-dominant strain that crosses Blueberry with Haze and features notes of berry, pine, and citrus.',13.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Sensi Star Pre-Roll',2,'Sweet, sour, piney, and fruity aromas.',12.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('White Widow Pre-Roll',2,'High-THC hybrid with frosty hand-trimmed flowers. Aroma of a pine forest blooming with flowers.',9.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Pink Lemonade Seeds',3,'Four seeds of the high-THC hybrid Pink Lemonade from Pink Kush and Lemon Skunk lineage. This strain smells fruity, with notes of lemon and grapefruit on the exhale.',44.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Northern Lights Seeds',3,'Four seeds for the indica-dominant, high-THC strain Northern Lights. This strain is 80% indica and 20% ruderalis and typically grows to be about a metre tall.',44.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('D3NALI Seeds',3,'Four seeds for an indoor sativa that averages about three feet in height, is resistant to botrytis, and has a flowering period of 56-65 days.',39.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Soft Baked Chocolate Chip Cookies',4,'A soft baked chocolate brownie-flavoured cookie infused with THC. Each pack has a total of 10mg of THC, comprising of two vegan, gluten-free, and nut-free cookies that each contain 5mg of THC.',11.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Sea Salt and Caramel Milk Chocolate',4,'Sea salt & caramel milk chocolate squares infused with THC from sativa-dominant blend of cannabis.',6.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('CBD Milk Chocolate',4,'Bhang® CBD Milk Chocolate combines rich, sustainably sourced 48% cocoa and 10mg of CBD. The bar is scored into four pieces and is produced in Indiva''s state-of-the-art facility based in London, Ontario',3.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Grapefruit Sparkling Water',5,'Houseplant Grapefruit is a naturally flavoured, cannabis-infused sparkling water with 2.5 mg of THC, extracted from Houseplant''s sativa-dominant strain.',4.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Backstreet and Ginger',5,'Combining Bakerstreet Distilled Cannabis with ginger ale and other ingredients, this sparkling beverage comes in a 355ml can and contains 2mg of THC.',3.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Lemon Sparkling Water',5,'Houseplant Lemon is a naturally flavoured, cannabis-infused sparkling water with 2.5 mg of THC.',4.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('High CBD Oil',6,'This pure, concentrated cannabis oil contains CBD, with only trace amounts of THC, and is formulated to be taken orally using the syringe included with the bottle.',39.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Balance Oil',6,'Solei Balance (Nordle) oil is a flavourless oil containing 1:1 of THC and CBD. It''s diluted in MCT oil and can be added to food and baking, or taken directly under the tongue.',24.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Gems 5:0',6,'GEMS are high-THC softgel capsules that contain MCT oil and a blended cannabis oil.',11.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Peach Mango Chews',7,'Two balanced peach mango flavoured chews with 5mg of CBD and 5mg of THC per chew. Pectin-based and vegan-friendly.',5.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Raspberry Gummies',7,'These sativa raspberry-flavoured gummies are infused with high-quality cannabinoid extract. Each pack contains a total of 10mg of THC, with four individual gummies containing 2.5mg each. ',7.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Grape Oasis Gummies',7,'Indica-dominant, grape-flavoured gummies, infused with high-quality cannabinoid extract. Each shareable pack contains 10mg of THC, with four individual gummies containing 2.5mg of THC each.',7.99);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 26.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 31.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 20.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 13.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 12.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 9.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 44.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 44.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 39.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 11.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (11, 1, 3, 6.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (12, 1, 3, 3.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (13, 1, 3, 4.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (14, 1, 3, 3.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (15, 1, 3, 4.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (16, 1, 3, 39.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (17, 1, 3, 24.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (18, 1, 3, 11.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (19, 1, 3, 5.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (20, 1, 3, 7.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (21, 1, 3, 7.99);


INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 64.96)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 26.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 12.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 11.99);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 64.95)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 12.99);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 154.95)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 9.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 44.99);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 315.84)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 20.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 44.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 4.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 17, 2, 24.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 4, 7.99);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 87.91)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 12.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 5.99)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 7.99);

-- New SQL DDL for lab 8
UPDATE product SET productImageURL = 'img/1.jpg' WHERE productId = 1;
UPDATE product SET productImageURL = 'img/2.jpg' WHERE productId = 2;
UPDATE product SET productImageURL = 'img/3.jpg' WHERE productId = 3;
UPDATE product SET productImageURL = 'img/4.jpg' WHERE productId = 4;
UPDATE product SET productImageURL = 'img/5.jpg' WHERE productId = 5;
UPDATE product SET productImageURL = 'img/6.jpg' WHERE productId = 6;
UPDATE product SET productImageURL = 'img/7.jpg' WHERE productId = 7;
UPDATE product SET productImageURL = 'img/8.jpg' WHERE productId = 8;
UPDATE product SET productImageURL = 'img/9.jpg' WHERE productId = 9;
UPDATE product SET productImageURL = 'img/10.jpg' WHERE productId = 10;
UPDATE product SET productImageURL = 'img/11.jpg' WHERE productId = 11;
UPDATE product SET productImageURL = 'img/12.jpg' WHERE productId = 12;
UPDATE product SET productImageURL = 'img/13.jpg' WHERE productId = 13;
UPDATE product SET productImageURL = 'img/14.jpg' WHERE productId = 14;
UPDATE product SET productImageURL = 'img/15.jpg' WHERE productId = 15;
UPDATE product SET productImageURL = 'img/16.jpg' WHERE productId = 16;
UPDATE product SET productImageURL = 'img/17.jpg' WHERE productId = 17;
UPDATE product SET productImageURL = 'img/18.jpg' WHERE productId = 18;
UPDATE product SET productImageURL = 'img/19.jpg' WHERE productId = 19;
UPDATE product SET productImageURL = 'img/20.jpg' WHERE productId = 20;
UPDATE product SET productImageURL = 'img/21.jpg' WHERE productId = 21;
