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


CREATE TABLE "employee"
(
    "employeeId"  int generated always as identity not null primary key,
    "homeAddress" varchar(50)                      not null,
    "startDate"   date                             not null,
    "endDate"     date default null,
    "salary"      int  default 0                   not null,
    "bankAccount" varchar(34)                      not null -- iban
);

CREATE TABLE "customer"
(
    "customerId"      int generated always as identity not null primary key,
    "login"           varchar(50)                      not null,
    "password"        varchar(50)                      not null,
    "deliveryAddress" varchar(50)                      not null
);

CREATE TABLE "user"
(
    "userId"       int generated always as identity not null primary key,
    "firstName"    varchar(50)                      not null,
    "lastName"     varchar(50)                      not null,
    "phoneNumber"  varchar(50)                      not null, -- varchar kvoli +421..
    "emailAddress" varchar(50)                      not null,
    "customerID"   int default null,
    "employeeID"   int default null,
    constraint FK_employeeID foreign key ("employeeID") references "employee" ("employeeId"),
    constraint FK_customerID foreign key ("customerID") references "customer" ("customerId")
);

CREATE TABLE "product"
(
    "productId"   int generated always as identity not null primary key,
    "productName" varchar(50)                      not null,
    "productDesc" varchar(50)                      not null,
    "category"    varchar(50)                      not null, -- maybe dropdown menu
    "visibility"  number default 0                 not null
);

CREATE TABLE "priceHistory"
(
    "startDate" date  not null,
    "endDate"   date  not null,
    "price"     float not null, -- maybe dropdown menu
    "productId" int default null,
    constraint FK_priceProductID foreign key ("productId") references "product" ("productId")
);



CREATE TABLE "warehouseStock"
(
    "productID" int default null,
    "quantity"  int default 0 not null,
    constraint FK_productID foreign key ("productID") references "product" ("productId")
);

CREATE TABLE "customerOrder"
(
    "customerOrderId"     int generated always as identity not null primary key,
    "customerID"          int default null,
    "customerOrderStatus" varchar(20)                      not null
);

CREATE TABLE "customerComplaint"
(
    "customerOrderId"         int generated always as identity not null primary key,
    "complaintDetail"         varchar(500)                     not null,
    "compaintDate"            date                             not null,
    "customerComplaintStatus" varchar(20)                      not null
);


CREATE TABLE "warehouseOrder"
(
    "warehouseOrderId"     int generated always as identity not null primary key,
    "supplier"             varchar(50)                      not null,
    "warehouseOrderStatus" varchar(20)                      not null
);

CREATE TABLE "order"
(
    "orderId"          int generated always as identity not null primary key,
    "orderDate"        date                             not null,
    "orderPrice"       float                            not null,
    "DeliveryAddress"  varchar(50)                      not null,
    "workerID"         int default null,
    "courierOrderId"   int default null,
    "customerOrderID"  int default null,
    "warehouseOrderID" int default null,
    constraint FK_workerID foreign key ("workerID") references "employee" ("employeeId"),
    constraint FK_customerOrderID foreign key ("customerOrderID") references "customerOrder" ("customerOrderId"),
    constraint FK_warehouseOrderID foreign key ("warehouseOrderID") references "warehouseOrder" ("warehouseOrderId")
);

CREATE TABLE "orderSpecification"
(
    "orderID"         int           not null,
    "productID"       int           not null,
    "productQuantity" int default 1 not null,
    constraint FK_orderID foreign key ("orderID") references "order" ("orderId"),
    constraint FK_productOrderID foreign key ("productID") references "product" ("productId")
);
-- employees
INSERT INTO "employee" ("homeAddress", "startDate", "salary", "bankAccount")
VALUES ('Bratislava, Slovakia', '05-AUG-18', 1500, 'SK00000000000000000000000000000001');
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
-- employees
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "employeeID")
VALUES ('Peter', 'Dlhy', '+421900000001', 'dlhy.peter@gmail.com', 1);
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "employeeID")
VALUES ('Matej', 'Kratky', '+421900000002', 'matko.kratky@gmail.com', 2);
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "employeeID")
VALUES ('Elizabeth', 'Pekna', '+421900000003', 'eli.kraska@gmail.com', 3);
-- customers
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "customerID")
VALUES ('Eugen', 'Cudny', '+421900000004', 'cudak.eugen@gmail.com', 1);
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "customerID")
VALUES ('Jozko', 'Vajda', '+421900000005', 'jozino.vajda@gmail.com', 2);
INSERT INTO "user" ("firstName", "lastName", "phoneNumber", "emailAddress", "customerID")
VALUES ('Lucia', 'Jemna', '+421900000006', 'jemna.lucka@gmail.com', 3);

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

INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productId")
VALUES ('01-Jan-21', '01-Mar-21', 248.99, 1);
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productId")
VALUES ('01-Jan-21', '01-Mar-21', 5.99, 2);
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productId")
VALUES ('01-Jan-21', '01-Mar-21', 60, 3);
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productId")
VALUES ('01-Jan-21', '01-Mar-21', 20, 4);
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productId")
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
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderId", "customerOrderID")
VALUES ('25-JAN-21', 11.98, 'Bratislava, Slovakia', 1, 111, 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "customerOrderID")
VALUES ('26-JAN-21', 120, 'Bratislava, Slovakia', 1, 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderId", "customerOrderID")
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