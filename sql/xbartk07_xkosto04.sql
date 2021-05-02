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

DROP MATERIALIZED VIEW "customer_total_money_spent";


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
VALUES (userID_seq.currval, 'Bratislava, Slovakia', '05-AUG-2018', 1500, '111333/2700');

INSERT INTO "user" VALUES (userID_seq.nextval, 'Matej', 'Kratky', '+421900000002', 'matko.kratky@gmail.com');
INSERT INTO "employee" ("employeeID", "homeAddress", "startDate", "endDate", "salary", "bankAccount")
VALUES (userID_seq.currval, 'Bratislava, Slovakia', '25-MAY-2019', '25-AUG-19', 700, '86-199488014/1111');

INSERT INTO "user" VALUES (userID_seq.nextval, 'Elizabeth', 'Pekna', '+421900000003', 'eli.kraska@gmail.com');
INSERT INTO "employee" ("employeeID", "homeAddress", "startDate", "salary", "bankAccount")
VALUES (userID_seq.currval, 'Bratislava, Slovakia', '01-JAN-2021', 1000, '111333/2700');

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
VALUES ('01-Jan-2021', '01-Mar-2021', 248.99, 1);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('02-Mar-2021', 235, 1);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('01-Jan-2021', 5.99, 2);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('01-Jan-2021', 60, 3);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('01-Jan-2021', 20, 4);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('01-Jan-2021', 35.99, 5);

----------stock----------
INSERT INTO "warehouseStock" ("productID", "quantity")  VALUES (1, 5);
INSERT INTO "warehouseStock" ("productID", "quantity")  VALUES (2, 20);
INSERT INTO "warehouseStock" ("productID")              VALUES (3);
INSERT INTO "warehouseStock" ("productID")              VALUES (4);
INSERT INTO "warehouseStock" ("productID", "quantity")  VALUES (5, 10);

----------customer_orders----------
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress")
VALUES ('25-JAN-2021', 31.98, 'Tulipánová 35, Bratislava, Slovakia');
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID")
VALUES ('26-JAN-2021', 180, 'Agátová 75, Bratislava, Slovakia', 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderID")
VALUES ('27-JAN-2021', 20, 'Balíková 111/23, Bratislava, Slovakia', 3, 77);

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
VALUES ('20-JAN-2021', 1000, 'Západná 721, Bratislava, Slovakia', 1, 1);
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress", "workerID", "courierOrderID")
VALUES ('15-JAN-2021', 300, 'Západná 721, Bratislava, Slovakia', 2, 1);

INSERT INTO "warehouseOrder" VALUES (1, 'Drevo s.r.o', 'Vybavena');
INSERT INTO "warehouseOrder" VALUES (2, 'Drevo s.r.o', 'Na ceste');

INSERT INTO "orderSpecification" VALUES (4, 1, 10);
INSERT INTO "orderSpecification" VALUES (5, 1, 5);


-----------------------------SELECTS-----------------------------
/*
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

-- Ktorí zákazníci si už objednali spolu za aspoň 20e?
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

-- Na objednávky ktorých zamestnancov nebola nikdy podaná sťažnosť?
SELECT e."employeeID", u."firstName", u."lastName"
FROM "user" u, "employee" e
WHERE e."employeeID" = u."userID" AND NOT EXISTS(
        SELECT *
        FROM "customerComplaint" c JOIN "order" o ON c."customerOrderID" = o."orderID"
        WHERE o."workerID" = e."employeeID"
);

-- Ktoré už nedostupné produkty si zákazníci objednávali?
SELECT os."productID"
FROM "orderSpecification" os JOIN "customerOrder" co ON os."orderID" = co."customerOrderID"
WHERE os."productID" IN (
    SELECT "productID"
    FROM "product"
    WHERE "visibility" = 0
    )
GROUP BY os."productID";
*/

-----------------------------TRIGGERS-----------------------------
-- Automatické doplnenie dátumu ukončenia ceny produktu po zadaní novej ceny
CREATE OR REPLACE TRIGGER price_update
BEFORE INSERT ON "priceHistory"
FOR EACH ROW
BEGIN
UPDATE "priceHistory" SET "endDate" = :new."startDate"
WHERE "productID" = :new."productID" AND "endDate" IS NULL;
END;

-- PRED priceHistory
SELECT * FROM "priceHistory" WHERE "productID" = 5;
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('10-Feb-21', 15, 5);
INSERT INTO "priceHistory" ("startDate", "price", "productID")
VALUES ('10-Mar-21', 25, 5);
-- PO priceHistory
SELECT * FROM "priceHistory" WHERE "productID" = 5;

-- Automatické generovanie ID pre users
CREATE OR REPLACE TRIGGER auto_id
    BEFORE INSERT ON "user"
    FOR EACH ROW
BEGIN
    IF  :NEW."userID" IS NULL THEN
        :NEW."userID" := userID_seq.nextval;
    END IF;
END;

-- PRED user
SELECT * FROM "user";
INSERT INTO "user"("firstName", "lastName", "phoneNumber", "emailAddress") VALUES ('Emanuel', 'Cudzi', '+421900000004', 'cudzi.emanuel@gmail.com');
INSERT INTO "user"("firstName", "lastName", "phoneNumber", "emailAddress") VALUES ('Ivan', 'Krehky', '+421900000004', 'krehky.ivan@gmail.com');
-- PO user
SELECT * FROM "user";


-----------------------------PROCEDURES-----------------------------
-- Zvýš plat všetkým aktuálnym zamestancom ktorí nastúpili pred daným dátumom
CREATE OR REPLACE PROCEDURE raise_by_date (date_str VARCHAR, ammount INTEGER) IS
    sal "employee"."salary"%type;
    eID "employee"."employeeID"%type;
    CURSOR emps IS SELECT "employeeID", "salary"
        FROM "employee" e WHERE e."startDate" < to_date(date_str,'YYYY-MM-DD');
BEGIN
    OPEN emps;
    LOOP
        FETCH emps INTO eID, sal;
        EXIT WHEN emps%NOTFOUND;
        UPDATE "employee"
        SET "salary" = sal + ammount
        WHERE "employeeID" = eID AND "endDate" IS NULL;
    END LOOP;
END;

-- Len zamestanec s employeeID = 1 by mal mať o 100 väčší plat
SELECT * FROM "employee";
CALL raise_by_date('2020-01-01', 100);
SELECT * FROM "employee";


-- Koľko objednávok s akou hodnotou v roku x
CREATE OR REPLACE PROCEDURE yearly_sales ( inYear IN NUMBER) IS
    "revenue" "order"."orderPrice"%TYPE := 0.;
    "order_count" NUMBER := 0;
    total_products_sold "orderSpecification"."productQuantity"%TYPE;
    "order_date" "order"."orderDate"%TYPE;
    "order_price" "order"."orderPrice"%TYPE;
    CURSOR "orders" IS SELECT "orderDate", "orderPrice" FROM "order" "o", "customerOrder" "co" WHERE "co"."customerOrderID" = "o"."orderID";
BEGIN
    SELECT SUM(os."productQuantity") INTO total_products_sold FROM "customerOrder" co, "orderSpecification" os
    WHERE co."customerOrderID" = os."orderID";

    OPEN "orders";
    LOOP
        FETCH "orders" INTO "order_date", "order_price";
        EXIT WHEN "orders"%NOTFOUND;
        IF EXTRACT(YEAR FROM "order_date") = inYear THEN
            "revenue" := "revenue"+ "order_price";
            "order_count" := "order_count"+1;
        END IF;
    END LOOP;
    CLOSE "orders";
    DBMS_OUTPUT.PUT_LINE('In year ' || inYear || ': ' || "order_count" || ' orders were made, where '|| total_products_sold ||' products total' ||
                         ' were sold with total revenue of ' || "revenue" || '€.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                DBMS_OUTPUT.put_line('There were no orders made in year ' ||inYear|| '.');
            END;
        WHEN VALUE_ERROR THEN
            BEGIN
                DBMS_OUTPUT.put_line('Bad format of year given. Expected YYYY');
            END;
END;

--- Súčet "orderPrice" sa zhoduje z výstupom procedúry "yearly_sales"
SELECT o."orderID","orderDate", "orderPrice"  FROM "customerOrder" co JOIN "order" o ON co."customerOrderID" = o."orderID" WHERE EXTRACT(YEAR FROM "orderDate") = 2021;
-- TEST
BEGIN yearly_sales(2021); END;


-- ktory produkt v kategorii "Spalna" bol objednany aspoň raz, koľkokrát dokopy a koľkátimi zákazníkmi
EXPLAIN PLAN FOR
SELECT p."productName" , SUM(os."productQuantity") as "pocet", COUNT(co."customerID") as "pocetZakaznikov" FROM "product" p JOIN "orderSpecification" os ON os."productID" = p."productID" JOIN "customerOrder" co ON os."orderID" = co."customerOrderID"
where p."category" LIKE '%Spalna%' GROUP BY p."productName" HAVING SUM(os."productQuantity") >= 1 ;
-- Zobrazenie planu
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY);

-- Index pre nazvy produktov
Drop INDEX "index_product_name";
Drop INDEX "index_order_spec";
CREATE INDEX "index_product_name" on "product"("productName");
Create INDEX  "index_order_spec" on "orderSpecification"("productID");
-- dalsi pokus s indexom
EXPLAIN PLAN FOR
SELECT p."productName" , SUM(os."productQuantity") as "pocet", COUNT(co."customerID") as "pocetZakaznikov" FROM "product" p JOIN "orderSpecification" os ON os."productID" = p."productID"
JOIN "customerOrder" co ON os."orderID" = co."customerOrderID"
where p."category" LIKE 'Spalna' GROUP BY p."productName" HAVING SUM(os."productQuantity") >= 1 ;
-- Zobrazenie indexovaneho planu
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY);


GRANT ALL ON "user" TO "XBARTK07";
GRANT ALL ON "employee" TO "XBARTK07";
GRANT ALL ON "customer" TO "XBARTK07";
GRANT ALL ON "order" TO "XBARTK07";
GRANT ALL ON "customerOrder" TO "XBARTK07";
GRANT ALL ON "warehouseOrder" TO "XBARTK07";
GRANT ALL ON "customerComplaint" TO "XBARTK07";
GRANT ALL ON "orderSpecification" TO "XBARTK07";
GRANT ALL ON "product" TO "XBARTK07";
GRANT ALL ON "warehouseStock" TO "XBARTK07";
GRANT ALL ON "priceHistory" TO "XBARTK07";

GRANT EXECUTE on yearly_sales TO "XBARTK07";

CREATE MATERIALIZED VIEW "customer_total_money_spent" AS
    SELECT u."userID", u."firstName", u."lastName", SUM(o."orderPrice") as "totalSpent"
    FROM "customerOrder" co,"order" o,"user" u
    LEFT JOIN "customer" c on u."userID" = c."customerID"
    WHERE co."customerID" = u."userID" and co."customerOrderID" = o."orderID"
    GROUP BY u."userID", u."firstName", u."lastName";

SELECT * FROM "customer_total_money_spent";

-- Pridanie dalsej objednavky
INSERT INTO "order" ("orderDate", "orderPrice", "DeliveryAddress") VALUES ('20-FEB-21', 10., 'Tulipánová 35, Bratislava, Slovakia');
INSERT INTO "customerOrder" VALUES (6, 4, 'Na ceste');
SELECT * FROM "order";
SELECT * FROM "customerOrder";

-- Materializovany pohlad sa nezmenil
SELECT * FROM "customer_total_money_spent";