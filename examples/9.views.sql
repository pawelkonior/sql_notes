SELECT *
FROM actor;


CREATE VIEW vw_all_actor
AS
SELECT *
FROM actor;

SELECT *
FROM vw_all_actor;

-- simplified queries

CREATE VIEW customer_payment
AS
SELECT pt.payment_id, cust.first_name, cust.last_name, amount, pt.rental_id
FROM payment pt
         INNER JOIN customer cust ON pt.customer_id = cust.customer_id
WHERE pt.amount > (SELECT AVG(pt2.amount)
                   FROM payment pt2
                   WHERE pt2.customer_id = pt.customer_id);


SELECT *
FROM customer_payment
LIMIT 500;

SELECT *
FROM rental
LIMIT 500;

SELECT *
FROM customer_payment cp
         INNER JOIN rental ren ON ren.rental_id = cp.rental_id;

-- Data security

SELECT *
FROM payment
LIMIT 500;

CREATE VIEW secure_data
AS
SELECT pt.payment_id, pt.rental_id, cust.first_name, cust.last_name, amount
FROM payment pt
         INNER JOIN customer cust ON pt.customer_id = cust.customer_id
WHERE pt.payment_id > 100;

SELECT *
FROM secure_data
LIMIT 500;

SELECT *
FROM secure_data
WHERE payment_id = 1
LIMIT 500;

SELECT payment_id, staff_id
FROM secure_data
LIMIT 500;

DROP VIEW secure_data;


-- DML operations

SELECT *
FROM language;

CREATE VIEW dml_operation
AS
SELECT *
FROM language;

# READ
SELECT *
FROM dml_operation
LIMIT 500;

# CREATE
INSERT INTO dml_operation (name, last_update)
VALUES ('Hindi', '2025-04-13 11:14');

# UPDATE
UPDATE dml_operation
SET name = 'Polish'
WHERE language_id = 7;

# DELETE
DELETE
FROM dml_operation
WHERE language_id = 7;

SHOW CREATE TABLE language;

CREATE VIEW dml_operation_2
AS
SELECT language_id, last_update
FROM language;

SELECT *
FROM dml_operation_2
LIMIT 500;

SHOW CREATE VIEW dml_operation_2;

INSERT INTO dml_operation_2 (name, last_update)
VALUES ('Polish', '2025-04-13 11:14');

UPDATE dml_operation_2
SET last_update = '2025-04-13 11:14'
WHERE language_id = 6;


CREATE VIEW dml_operation_3
AS
SELECT *
FROM language
WHERE YEAR(last_update) < 2010;

SELECT *
FROM dml_operation_3
LIMIT 500;

UPDATE dml_operation_3
SET last_update = '2007-04-13 11:14'
WHERE language_id = 6;


CREATE VIEW dml_operation_4
AS
SELECT *
FROM language
WHERE YEAR(last_update) < 2010
WITH CHECK OPTION;

SELECT *
FROM dml_operation_4
LIMIT 500;

UPDATE dml_operation_4
SET last_update = '2007-04-13 11:14'
WHERE language_id = 5;

UPDATE dml_operation_4
SET last_update = '2011-04-13 11:14'
WHERE language_id = 5;

UPDATE dml_operation_3
SET last_update = '2011-04-13 11:14'
WHERE language_id = 5;
