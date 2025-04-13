# zlicza wszystko zawsze
SELECT COUNT(*)
FROM rental;

# zlicza wszystko zawsze
SELECT COUNT(1)
FROM rental;

# nie zlicza wartości komórki, która ma NULL
SELECT COUNT(customer_id)
FROM rental;


SELECT *
FROM rental
LIMIT 500;


SELECT COUNT(*), customer_id
FROM rental
GROUP BY customer_id
LIMIT 500;

SELECT MAX(rental_date), customer_id
FROM rental
GROUP BY customer_id
LIMIT 500;

SELECT MIN(rental_date), customer_id
FROM rental
GROUP BY customer_id
LIMIT 500;


SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) rental_span_days, customer_id
FROM rental
GROUP BY customer_id
ORDER BY rental_span_days DESC
LIMIT 500;

SELECT customer_id, AVG(amount) AveragePayment, SUM(amount) TotalPayment, COUNT(*) TotalRentals
FROM payment
GROUP BY customer_id
HAVING TotalPayment > 150
ORDER BY TotalPayment DESC
LIMIT 10;


-- category name, count(film)

SELECT ct.name, COUNT(*) total_movies
FROM category ct
         LEFT JOIN sakila.film_category fc ON ct.category_id = fc.category_id
GROUP BY ct.category_id
ORDER BY total_movies DESC
LIMIT 500;

SELECT c.name, COUNT(*)
FROM film_category fc
         LEFT JOIN sakila.category c on fc.category_id = c.category_id
         RIGHT JOIN sakila.film f on fc.film_id = f.film_id
GROUP BY c.name
ORDER BY c.name
LIMIT 500;


-- all customers, payment > avg payment

SELECT ct.first_name, ct.last_name, pt.amount
FROM payment pt
         INNER JOIN customer ct ON pt.customer_id = ct.customer_id
WHERE pt.amount > (SELECT AVG(pt2.amount)
                   FROM payment pt2);

SELECT AVG(pt.amount)
FROM payment pt;

-- all customers, count(payment > avg payment),

SELECT ct.first_name, ct.last_name, COUNT(pt.amount)
FROM payment pt
         INNER JOIN customer ct ON pt.customer_id = ct.customer_id
WHERE pt.amount > (SELECT AVG(pt2.amount)
                   FROM payment pt2)
GROUP BY ct.customer_id
LIMIT 500;

-- all customers, count(payment > avg payment customer),

SELECT ct.first_name, ct.last_name, COUNT(pt.amount)
FROM payment pt
         INNER JOIN customer ct ON pt.customer_id = ct.customer_id
WHERE pt.amount > (SELECT AVG(pt2.amount)
                   FROM payment pt2
                   WHERE pt2.customer_id = pt.customer_id)
GROUP BY ct.customer_id
LIMIT 500;


# CTE = common table expression

WITH avg_payment_per_customer AS (SELECT customer_id,
                                         AVG(amount) AS avg_amount
                                  FROM payment
                                  GROUP BY customer_id)

SELECT c.first_name,
       c.last_name,
       COUNT(p.amount)
FROM payment p
         INNER JOIN avg_payment_per_customer appc ON appc.customer_id = p.customer_id
         INNER JOIN customer c ON p.customer_id = c.customer_id
WHERE p.amount > appc.avg_amount
GROUP BY c.customer_id
LIMIT 500;


