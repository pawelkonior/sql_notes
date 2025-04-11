# CRUD = create, read, update, delete

# SELECT col_names FROM table_name;

SELECT *
FROM actor;

SELECT 1 + 1;
SELECT NOW();

SELECT actor_id, first_name, last_name, last_update
FROM actor;

SELECT *
FROM city;

SELECT first_name, last_name
FROM actor;

SELECT first_name, last_name
FROM actor
ORDER BY first_name;

SELECT first_name, last_name
FROM actor
ORDER BY first_name DESC;

SELECT first_name, last_name
FROM actor
ORDER BY first_name
LIMIT 501;

SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id > 100
LIMIT 501;

SELECT first_name, last_name
FROM actor
WHERE first_name = 'NICK'
ORDER BY actor_id DESC
LIMIT 500;

SELECT ren.rental_date AS 'Rental Date', ren.inventory_id AS Inventory
FROM rental AS ren
LIMIT 500;

SELECT ren.rental_date 'Rental Date', ren.inventory_id Inventory
FROM rental ren
LIMIT 500;


SELECT replacement_cost - rental_rate AS CostDiff, length / 60 AS TimeInHours
FROM film
LIMIT 500;


SELECT rental_rate                 AS RentalRate,
       rental_rate + 3 * 4 - 1     AS Result1,
       (rental_rate + 3) * 4 - 1   AS Result2,
       (rental_rate + 3) * (4 - 1) AS Result3,
       rental_rate + (3 * 4) - 1   AS Result4
FROM sakila.film;

SELECT replacement_cost       AS ReplacementCost,
       replacement_cost / 5   AS DecimalRentalRate,
       replacement_cost DIV 5 AS IntegerReplacementRate,
       replacement_cost % 5   AS ReminderRentalRate
FROM film

LIMIT 501;

SELECT amount,
       ROUND(amount)    AS Amnt,
       ROUND(amount, 1) AS Amnt1,
       FLOOR(amount)    AS FloorAmnt,
       CEILING(amount)  AS CeilingAmnt
FROM payment
LIMIT 501;

SELECT CONCAT(first_name, ' ', last_name)                        AS FullName,
       CONCAT(LEFT(first_name, 1), '.', LEFT(last_name, 1), '.') AS Initials,
       LENGTH(CONCAT(first_name, last_name))                     AS Length,
       REVERSE(CONCAT(first_name, ' ', last_name))               AS ReversedFullName,
       REPLACE(CONCAT(first_name, ' ', last_name), 'S', '$')     AS ReplaceEx
FROM actor
LIMIT 501;

SELECT CONCAT(first_name, ' ', last_name)         AS FullName,
       DATE_FORMAT(last_update, '%m/%d/%y')       AS LastUpdate1,
       DATE_FORMAT(last_update, '%m-%d-%Y')       AS LastUpdate2,
       DATE_FORMAT(last_update, '%d %b %Y %T:%f') AS LastUpdate3
FROM actor
LIMIT 501;

SELECT CONCAT(first_name, ' ', last_name)                AS FullName,
       DATE_FORMAT(last_update, GET_FORMAT(DATE, 'ISO')) AS LastUpdateISO,
       DATE_FORMAT(last_update, GET_FORMAT(DATE, 'USA')) AS LastUpdateUSA,
       DATE_FORMAT(last_update, GET_FORMAT(DATE, 'EUR')) AS LastUpdateEUR
FROM actor
LIMIT 501;

SELECT rental_date,
       DAYOFWEEK(rental_date) AS DayOfWeek,
       QUARTER(rental_date)   AS Quarter,
       WEEK(rental_date)      AS Week,
       MONTHNAME(rental_date) AS MonthName
FROM rental
LIMIT 501;


SELECT DISTINCT first_name
FROM actor
ORDER BY first_name
LIMIT 500;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id = 100
LIMIT 500;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name < 'NICK'
LIMIT 500;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id <= 100
LIMIT 500;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id != 100
LIMIT 500;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id <> 100
LIMIT 500;


SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'KENNETH'
  AND actor_id < 100
LIMIT 500;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'KENNETH'
   OR actor_id < 100
LIMIT 500;

SELECT actor_id, first_name, last_name
FROM actor
WHERE NOT actor_id = 5
LIMIT 500;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'KENNETH' AND actor_id < 100
   OR last_name = 'TEMPLE'
LIMIT 501;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'KENNETH'
   OR last_name = 'TEMPLE' AND actor_id < 100
LIMIT 501;

SELECT actor_id, first_name, last_name
FROM actor
WHERE (first_name = 'KENNETH' OR last_name = 'TEMPLE')
  AND actor_id < 100
LIMIT 501;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'KENNETH'
   OR (last_name = 'TEMPLE' AND actor_id < 100)
LIMIT 501;

SELECT actor_id, first_name, last_name
FROM actor
WHERE NOT (first_name = 'KENNETH' OR (last_name = 'TEMPLE' AND actor_id < 100))
LIMIT 501;

SELECT *
FROM actor
WHERE first_name IN ("NICK", "JOHN", "JOE", "VIVIEN")
LIMIT 500;

SELECT *
FROM actor
WHERE actor_id NOT IN (1, 3, 5, 7)
LIMIT 500;


SELECT *
FROM actor
WHERE first_name IN ("NICK", "JOHN", "JOE", "VIVIEN")
  AND actor_id IN (SELECT actor_id
                   FROM actor
                   WHERE last_name = "DEGENERES")
LIMIT 500;

SELECT *
FROM actor
WHERE actor_id BETWEEN 10 AND 20
LIMIT 500;

SELECT *
FROM actor
WHERE actor_id NOT BETWEEN 10 AND 20
LIMIT 500;


SELECT *
FROM actor
WHERE first_name LIKE 'A%'
LIMIT 500;

SELECT *
FROM actor
WHERE first_name LIKE 'AL%'
LIMIT 500;

SELECT *
FROM actor
WHERE first_name LIKE 'A__E'
LIMIT 500;

SELECT *
FROM actor
WHERE first_name LIKE 'A__E%'
LIMIT 500;

SELECT *
FROM actor
WHERE first_name LIKE 'A%E%'
LIMIT 500;

SELECT *
FROM actor
WHERE first_name NOT LIKE 'A%' AND first_name NOT LIKE '%A'
LIMIT 500;

SELECT *
FROM actor
WHERE NOT (first_name LIKE 'A%' OR first_name LIKE '%A')
LIMIT 500;


SELECT *
FROM address
LIMIT 5;


SELECT *
FROM address
LIMIT 5 OFFSET 10;

SELECT CONCAT(first_name, " ", last_name)
FROM actor
ORDER BY CONCAT(first_name, " ", last_name)
LIMIT 500;

SELECT CONCAT(first_name, " ", last_name) AS FullName
FROM actor
ORDER BY FullName
LIMIT 500;

SELECT district, postal_code
FROM address
ORDER BY district, postal_code DESC
LIMIT 500;