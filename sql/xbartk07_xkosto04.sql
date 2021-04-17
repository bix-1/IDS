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
    "emailAddress" varchar(50)                      not null,
    CONSTRAINT email_format
        CHECK (REGEXP_LIKE("emailAddress", '^[a-zA-Z0-9]([a-zA-Z0-9]|[._\-][a-zA-Z0-9])*@[a-zA-Z0-9]([a-zA-Z0-9]|\-[a-zA-Z0-9])*\.[a-z][a-z]+$')),
    CONSTRAINT phone_format CHECK (REGEXP_LIKE("phoneNumber", '^\+[0-9]{12}$'))
);

CREATE TABLE "employee"
(
    "employeeID"  int not null primary key,
    "homeAddress" varchar(50)                      not null,
    "startDate"   date                             not null,
    "endDate"     date default null,
    "salary"      int  default 0                   not null,
    "bankAccount" varchar(30)                      not null, -- iban
    constraint FK_employeeID foreign key ("employeeID") references "user" ("userID"),
    CONSTRAINT bankAccount_format
        CHECK (REGEXP_LIKE("bankAccount", '^((([0-9]{1,6})-)([0-9]{2,10})/([0-9]{4}))|(([0-9]{2,10})/([0-9]{4}))$'))
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
    constraint PK_priceHistory primary key ("productID", "startDate"),
    constraint FK_priceProductID foreign key ("productID") references "product" ("productID")
);

CREATE TABLE "warehouseStock"
(
    "productID" int not null primary key,
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
    constraint PK_orderSpecification primary key ("orderID", "productID"),
    constraint FK_orderID foreign key ("orderID") references "order" ("orderID"),
    constraint FK_productID foreign key ("productID") references "product" ("productID")
);

DROP SEQUENCE userID_seq;
CREATE SEQUENCE userID_seq;


-----------------------------INSERTS-----------------------------
----------employees----------
INSERT INTO "user" VALUES (userID_seq.nextval, 'Peter', 'Dlhy', '+421900000001', 'dlhy.peter@gmail.com');
INSERT INTO "employee" ("employeeID", "homeAddress", "startDate", "salary", "bankAccount")
VALUES (userID_seq.currval, 'Bratislava, Slovakia', '05-AUG-18', 1500, '111333/2700');

INSERT INTO "user" VALUES (userID_seq.nextval, 'Matej', 'Kratky', '+421900000002', 'matko.kratky@gmail.com');
INSERT INTO "employee" ("employeeID", "homeAddress", "startDate", "endDate", "salary", "bankAccount")
VALUES (userID_seq.currval, 'Bratislava, Slovakia', '25-MAY-19', '25-AUG-19', 700, '86-199488014/1111');

INSERT INTO "user" VALUES (userID_seq.nextval, 'Elizabeth', 'Pekna', '+421900000003', 'eli.kraska@gmail.com');
INSERT INTO "employee" ("employeeID", "homeAddress", "startDate", "salary", "bankAccount")
VALUES (userID_seq.currval, 'Bratislava, Slovakia', '01-JAN-21', 1000, '111333/2700');

----------customers----------
INSERT INTO "user" VALUES (userID_seq.nextval, 'Eugen', 'Cudny', '+421900000004', 'cudak.eugen@gmail.com');
INSERT INTO "customer" VALUES (userID_seq.currval, 'eugenko', 'eugen123', 'Slovakia', 'Bratislava');

INSERT INTO "user" VALUES (userID_seq.nextval, 'Jozko', 'Vajda', '+421900000005', 'jozino.vajda@gmail.com');
INSERT INTO "customer" VALUES (userID_seq.currval, 'jozino', 'vajda123', 'Slovakia', 'Bratislava');

INSERT INTO "customer" VALUES (1, 'peter', 'dlhy123', 'Slovakia', 'Bratislava');

----------products----------
INSERT INTO "product" ("productName", "productDesc", "category", "visibility")
VALUES ('Stol', 'Okruhly stol pre styroch', 'Kuchyna', 1);
INSERT INTO "product" ("productName", "productDesc", "category", "visibility")
VALUES ('Sviecka', 'Sviecka s vonou manga', 'Doplnky do bytu', 1);
INSERT INTO "product" ("productName", "productDesc", "category")
VALUES ('Zrkadlo', 'Zrkadlo s LED podsvietenim', 'Spalna');
INSERT INTO "product" ("productName", "productDesc", "category")
VALUES ('Policka', 'Policka na knihy', 'Spalna/Obyvacka');
INSERT INTO "product" ("productName", "productDesc", "category", "visibility")
VALUES ('Stolicka', 'Pevna stolicka so zeleznou konstrukciou', 'Kuchyna', 1);

----------prices----------
INSERT INTO "priceHistory" ("startDate", "endDate", "price", "productID")
VALUES ('01-Jan-21', '01-Mar-21', 248.99, 1);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('02-Mar-21', 235, 1);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('01-Jan-21', 5.99, 2);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('01-Jan-21', 60, 3);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('01-Jan-21', 20, 4);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('01-Jan-21', 35.99, 5);

----------stock----------
INSERT INTO "warehouseStock" ("productID", "quantity")  VALUES (1, 5);
INSERT INTO "warehouseStock" ("productID", "quantity")  VALUES (2, 20);
INSERT INTO "warehouseStock" ("productID")              VALUES (3);
INSERT INTO "warehouseStock" ("productID")              VALUES (4);
INSERT INTO "warehouseStock" ("productID", "quantity")  VALUES (5, 10);

----------customer_orders----------
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress")
VALUES ('25-JAN-21', 31.98, 'Tulipánová 35, Bratislava, Slovakia');
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID")
VALUES ('26-JAN-21', 180, 'Agátová 75, Bratislava, Slovakia', 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderID")
VALUES ('27-JAN-21', 20, 'Balíková 111/23, Bratislava, Slovakia', 3, 77);

INSERT INTO "customerOrder" VALUES (1, 4, 'Na ceste');
INSERT INTO "customerOrder" VALUES (2, 4, 'Nedostupne');
INSERT INTO "customerOrder" VALUES (3, 5, 'Dorucene');

INSERT INTO "orderSpecification" VALUES (1, 2, 2);
INSERT INTO "orderSpecification" VALUES (1, 4, 1);
INSERT INTO "orderSpecification" VALUES (2, 3, 3);
INSERT INTO "orderSpecification" VALUES (3, 4, 1);

----------complaint----------
INSERT INTO "customerComplaint" VALUES (2, 'Preco to tak dlho trva??? Prajem pekny den', '01-Mar-21', 'Spracovava sa');

----------warehouse_orders----------
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderID")
VALUES ('20-JAN-21', 1000, 'Západná 721, Bratislava, Slovakia', 1, 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderID")
VALUES ('15-JAN-21', 300, 'Západná 721, Bratislava, Slovakia', 2, 1);

INSERT INTO "warehouseOrder" VALUES (1, 'Drevo s.r.o', 'Vybavena');
INSERT INTO "warehouseOrder" VALUES (2, 'Drevo s.r.o', 'Na ceste');

INSERT INTO "orderSpecification" VALUES (4, 1, 10);
INSERT INTO "orderSpecification" VALUES (5, 1, 5);


-----------------------------SELECTS-----------------------------
/* TODO detele this list & uncomment all selects LEAVING THE DESCRIPTIONS
   2 dotazy využívající spojení dvou tabulek
   1 využívající spojení tří tabulek
   2 dotazy s klauzulí GROUP BY a agregační funkcí
   1 dotaz obsahující predikát EXISTS
   1 dotaz s predikátem IN s vnořeným selectem
 */


-- Koľko kusov tovaru obsahuje objednávka 1?

SELECT SUM(o."productQuantity")
FROM "customerOrder" c JOIN "orderSpecification" o ON c."customerOrderID" = o."orderID"
WHERE c."customerOrderID" = 1;


-- Koľko je na sklade tovaru podľa kategórie?

SELECT p."category", SUM(ws."quantity")
FROM "product" p, "warehouseStock" ws
WHERE p."productID" = ws."productID"
GROUP BY p."category";


-- Ktorí zamestanci majú aj zákaznícke účty?

SELECT u."userID", u."firstName", u."lastName"
FROM "user" u, "employee" e, "customer" c
WHERE e."employeeID" = c."customerID" AND u."userID" = e."employeeID";


-- Na objednávky ktorých zamestnancov nebola nikdy podaná sťažnosť?

SELECT e."employeeID", u."firstName", u."lastName"
FROM "user" u, "employee" e
WHERE e."employeeID" = u."userID" AND NOT EXISTS(
        SELECT *
        FROM "customerComplaint" c JOIN "order" o ON c."customerOrderID" = o."orderID"
        WHERE o."workerID" = e."employeeID"
);


-- Ktorí zákazníci si už objednali spolu za viac ako 20e?

SELECT CO."customerID", SUM(O."orderPrice")
FROM "customerOrder" CO, "order" O
WHERE CO."customerOrderID" = O."orderID"
GROUP BY CO."customerID"
HAVING SUM(O."orderPrice") >= 20;


-- Ktorý produkt si zákazníci objednávali najviac?

SELECT P."productID", P."productName", sums.sumOrds
FROM (
         SELECT OS."productID" pID, SUM(OS."productQuantity") sumOrds
         FROM "order" O
                  JOIN "customerOrder" CO ON O."orderID" = CO."customerOrderID"
                  NATURAL JOIN "orderSpecification" OS
         GROUP BY OS."productID"
         ORDER BY sumOrds desc
     ) sums, "product" P
WHERE rownum = 1 AND P."productID" = sums.pID;


-- Ktoré už nedostupné produkty si zákazníci objednávali?

SELECT os."productID"
FROM "orderSpecification" os JOIN "customerOrder" co ON os."orderID" = co."customerOrderID"
WHERE os."productID" IN (
    SELECT "productID"
    FROM "product"
    WHERE "visibility" = 0
    )
GROUP BY os."productID";
