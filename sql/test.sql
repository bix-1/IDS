ALTER SESSION SET nls_date_format = 'DD-MON-YYYY';

drop table "orderSpecification" cascade constraints;
drop table "order" cascade constraints;
drop table "warehouseOrder" cascade constraints;
drop table "customerComplaint" cascade constraints;
drop table "customerOrder" cascade constraints;
drop table "warehouseStock" cascade constraints;
drop table "product" cascade constraints;
drop table "priceHistory" cascade constraints;
drop table "user" cascade constraints;
drop table "customer" cascade constraints;
drop table "employee" cascade constraints;


------------------------------ACCOUNTS------------------------------
CREATE TABLE "user"
(
    "userID"       int not null primary key,
    "firstName"    varchar(50)                      not null,
    "lastName"     varchar(50)                      not null,
    "phoneNumber"  varchar(50)                      not null, -- varchar kvoli +421..
    "emailAddress" varchar(50)                      not null
);

CREATE TABLE "employee"
(
    "employeeID"  int not null primary key,
    "homeAddress" varchar(50)                      not null,
    "startDate"   date                             not null,
    "endDate"     date default null,
    "salary"      int  default 0                   not null,
    "bankAccount" varchar(34)                      not null, -- iban
    constraint FK_employeeID foreign key ("employeeID") references "user" ("userID")
);

CREATE TABLE "customer"
(
    "customerID"      int not null primary key,
    "login"           varchar(50)                      not null,
    "password"        varchar(50)                      not null,
    "country"         varchar(50)                      not null,
    "deliveryAddress" varchar(50)                      not null,
    constraint FK_customerID foreign key ("customerID") references "user" ("userID")
);


------------------------------PRODUCTS------------------------------
CREATE TABLE "product"
(
    "productID"   int generated always as identity not null primary key,
    "productName" varchar(50)                      not null,
    "productDesc" varchar(500)                     not null,
    "category"    varchar(50)                      not null,
    "visibility"  number(1) default 0              not null
);

CREATE TABLE "priceHistory"
(
    "productID" int not null,
    "startDate" date not null,
    "endDate"   date default null,
    "price"     float not null,
    constraint FK_priceProductID foreign key ("productID") references "product" ("productID")
);

CREATE TABLE "warehouseStock"
(
    "productID" int not null,
    "quantity"  int default 0 not null,
    constraint FK_whStockProductID foreign key ("productID") references "product" ("productID")
);


------------------------------ORDERS------------------------------
CREATE TABLE "order"
(
    "orderID"          int generated always as identity not null primary key,
    "orderDate"        date                             not null,
    "orderPrice"       float                            not null,
    "DeliveryAddress"  varchar(50)                      not null,
    "workerID"         int default null,
    "courierOrderID"   int default null
    --"customerOrderID"  int default null,
    --"warehouseOrderID" int default null,
    --constraint FK_workerID foreign key ("workerID") references "employee" ("employeeID"),
    --constraint FK_customerOrderID foreign key ("customerOrderID") references "customerOrder" ("customerOrderID"),
    --constraint FK_warehouseOrderID foreign key ("warehouseOrderID") references "warehouseOrder" ("warehouseOrderID")
);

CREATE TABLE "customerOrder"
(
    "customerOrderID"     int not null primary key,
    "customerID"          int not null,
    "customerOrderStatus" varchar(20) not null,
    constraint FK_customerOrderID foreign key ("customerOrderID") references "order" ("orderID"),
    constraint FK_COcustomerID foreign key ("customerID") references "customer" ("customerID")
);

CREATE TABLE "customerComplaint"
(
    "customerOrderID"         int not null primary key,
    "complaintDetail"         varchar(500)  not null,
    "compaintDate"            date          not null,
    "customerComplaintStatus" varchar(20)   not null,
    constraint FK_customerComplaint_orderID foreign key ("customerOrderID") references "order" ("orderID")
);


CREATE TABLE "warehouseOrder"
(
    "warehouseOrderID"     int not null primary key,
    "supplier"             varchar(50)  not null,
    "warehouseOrderStatus" varchar(20)  not null,
    constraint FK_warehouseOrderID foreign key ("warehouseOrderID") references "order" ("orderID")
);

CREATE TABLE "orderSpecification"
(
    "orderID"         int           not null,
    "productID"       int           not null,
    "productQuantity" int default 1 not null,
    constraint FK_orderID foreign key ("orderID") references "order" ("orderID"),
    constraint FK_productID foreign key ("productID") references "product" ("productID")
);

CREATE SEQUENCE userID_seq;

-- employees
INSERT INTO "user" VALUES (userID_seq.nextval, 'Peter', 'Dlhy', '+421900000001', 'dlhy.peter@gmail.com');
INSERT INTO "employee" ("employeeID", "homeAddress", "startDate", "salary", "bankAccount")
VALUES (userID_seq.currval, 'Bratislava, Slovakia', '05-AUG-18', 1500, 'SK00000000000000000000000000000001');
/*
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "employeeID")
VALUES ('Matej', 'Kratky', '+421900000002', 'matko.kratky@gmail.com', 2);
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "employeeID")
VALUES ('Elizabeth', 'Pekna', '+421900000003', 'eli.kraska@gmail.com', 3);
 */
/*
-- customers
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "customerID")
VALUES ('Eugen', 'Cudny', '+421900000004', 'cudak.eugen@gmail.com', 1);
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "customerID")
VALUES ('Jozko', 'Vajda', '+421900000005', 'jozino.vajda@gmail.com', 2);
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "customerID")
VALUES ('Lucia', 'Jemna', '+421900000006', 'jemna.lucka@gmail.com', 3);
-- employees
INSERT INTO "employee" ("homeAddress", "startDate", "endDate", "salary", "bankAccount")
VALUES ('Bratislava, Slovakia', '25-MAY-19', '25-AUG-19', 700, 'SK00000000000000000000000000000002');
INSERT INTO "employee" ("homeAddress", "startDate", "salary", "bankAccount")
VALUES ('Bratislava, Slovakia', '01-JAN-21', 1000, 'SK00000000000000000000000000000003');
-- customers
INSERT INTO "customer" ("login", "password", "deliveryAddress")
VALUES ('eugenko', 'eugen123', 'Bratislava, Slovakia');
INSERT INTO "customer" ("login", "password", "deliveryAddress")
VALUES ('jozino', 'vajda123', 'Bratislava, Slovakia');
INSERT INTO "customer" ("login", "password", "deliveryAddress")
VALUES ('lucka', 'jemna123', 'Bratislava, Slovakia');

INSERT INTO "product" ("productName", "productDesc", "category", "visibility")
VALUES ('Stol', 'Okruhly stol pre styroch', 'Kuchyna', 1);
INSERT INTO "product" ("productName", "productDesc", "category", "visibility")
VALUES ('Sviecka', 'Sviecka s vonou manga', 'Doplnky do bytu', 1);
INSERT INTO "product" ("productName", "productDesc", "category", "visibility")
VALUES ('Zrkadlo', 'Zrkadlo s LED podsvietenim', 'Spalna', 0);
INSERT INTO "product" ("productName", "productDesc", "category", "visibility")
VALUES ('Policka', 'Policka na knihy', 'Spalna/Obyvacka', 0);
INSERT INTO "product" ("productName", "productDesc", "category", "visibility")
VALUES ('Stolicka', 'Pevna stolicka so zeleznou konstrukciou', 'Kuchyna', 1);

INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productID")
VALUES ('01-Jan-21', '01-Mar-21', 248.99, 1);
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productID")
VALUES ('01-Jan-21', '01-Mar-21', 5.99, 2);
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productID")
VALUES ('01-Jan-21', '01-Mar-21', 60, 3);
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productID")
VALUES ('01-Jan-21', '01-Mar-21', 20, 4);
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productID")
VALUES ('01-Jan-21', '01-Mar-21', 35.99, 5);

INSERT INTO "warehouseStock" ("productID", "quantity")
VALUES (1, 5);
INSERT INTO "warehouseStock" ("productID", "quantity")
VALUES (2, 20);
INSERT INTO "warehouseStock" ("productID", "quantity")
VALUES (3, 0);
INSERT INTO "warehouseStock" ("productID", "quantity")
VALUES (4, 0);
INSERT INTO "warehouseStock" ("productID", "quantity")
VALUES (5, 10);

INSERT INTO "customerOrder" ("customerID", "customerOrderStatus")
VALUES (1, 'Na ceste');
INSERT INTO "customerOrder" ("customerID", "customerOrderStatus")
VALUES (2, 'Nedostupne');
INSERT INTO "customerOrder" ("customerID", "customerOrderStatus")
VALUES (3, 'Dorucene');

INSERT INTO "customerComplaint" ("complaintDetail", "compaintDate", "customerComplaintStatus")
VALUES ('Preco to tak dlho trva???', '01-AUG-21', 'Spracovava sa');

INSERT INTO "warehouseOrder" ("supplier", "warehouseOrderStatus")
VALUES ('Drevo s.r.o', 'Vybavena');
INSERT INTO "warehouseOrder" ("supplier", "warehouseOrderStatus")
VALUES ('Drevo s.r.o', 'Spracovava sa');
-- customer order
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderID", "customerOrderID")
VALUES ('25-JAN-21', 11.98, 'Bratislava, Slovakia', 1, 111, 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "customerOrderID")
VALUES ('26-JAN-21', 120, 'Bratislava, Slovakia', 1, 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderID", "customerOrderID")
VALUES ('27-JAN-21', 20, 'Bratislava, Slovakia', 3, 222, 3);
-- warehouse order
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "customerOrderID")
VALUES ('20-JAN-21', 1000, 'Bratislava, Slovakia', 1, 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "customerOrderID")
VALUES ('15-JAN-21', 300, 'Bratislava, Slovakia', 1, 1);

INSERT INTO "orderSpecification" ("orderID", "productID", "productQuantity")
VALUES (1, 1, 2);
INSERT INTO "orderSpecification" ("orderID", "productID", "productQuantity")
VALUES (2, 1, 2);
INSERT INTO "orderSpecification" ("orderID", "productID", "productQuantity")
VALUES (3, 1, 2);

INSERT INTO "orderSpecification" ("orderID", "productID", "productQuantity")
VALUES (4, 1, 10);
INSERT INTO "orderSpecification" ("orderID", "productID", "productQuantity")
VALUES (5, 1, 5);
 */

SELECT * from "user";
SELECT * from "employee";