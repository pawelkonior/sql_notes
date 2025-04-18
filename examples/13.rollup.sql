SELECT *
FROM payment
LIMIT 500;

# całkowita kwota wpływów do wypożyczalni

SELECT SUM(amount)
FROM payment
LIMIT 500;


# kwotę wpływów w podziale na klientów

SELECT customer_id, SUM(amount) AS Amount
FROM payment
GROUP BY customer_id
ORDER BY Amount DESC
LIMIT 500;

# kwota wpływów w podziale na pracownika

SELECT staff_id, SUM(amount) AS Amount
FROM payment
GROUP BY staff_id
ORDER BY Amount DESC
LIMIT 500;

# kwotę wpływów w podziale na klientów i miesiące


SELECT customer_id,
       DATE_FORMAT(payment_date, '%Y-%m') AS PaymentMonth,
       SUM(amount) AS Amount
FROM payment
GROUP BY customer_id, PaymentMonth
ORDER BY customer_id, Amount DESC
LIMIT 500;


SELECT staff_id,
       DATE_FORMAT(payment_date, '%Y-%m') AS PaymentMonth,
       SUM(amount) AS Amount
FROM payment
GROUP BY staff_id, PaymentMonth
ORDER BY staff_id, Amount DESC
LIMIT 500;



# Przygotuj raport wpłatowy na podstawie odpowiednich tabel z bazy sakila, który wyświetli następujące informacje:
#
# imię klienta,
# nazwisko klienta,
# email klienta,
# kwotę wpłat,
# liczbę wpłat,
# średnią kwotę wpłat,
# datę ostatniej wpłaty.
# Wynik zapytania zapisz w bazie używając widoku.

CREATE OR REPLACE VIEW payment_report
AS
SELECT cust.first_name,
       cust.last_name,
       cust.email,
       SUM(p.amount) AS CustomerTotal,
       COUNT(p.amount) AS CustomerPaymentCount,
       AVG(p.amount) AS CustomerAvgPayment,
       MAX(p.payment_date) AS CustomerLastPayment
FROM customer cust
JOIN payment p ON cust.customer_id = p.customer_id
GROUP BY cust.customer_id;

SELECT *
FROM payment_report
LIMIT 500;

# test
SELECT (SELECT SUM(CustomerTotal) FROM payment_report) = (SELECT SUM(amount) FROM payment);


# Napisz kwerendę, która zwróci następujące informacje:
#
# id filmu,
# nazwę filmu,
# liczbę aktorów występujących w filmie.
# Wyniki zapisz do tabeli tymczasowej, np. tmp_film_actors.

CREATE TEMPORARY TABLE tmp_film_actors
AS
SELECT fl.film_id,
       fl.title,
       COUNT(fa.actor_id) AS ActorsCount
FROM film fl
JOIN film_actor fa ON fl.film_id = fa.film_id
GROUP BY fl.film_id
ORDER BY ActorsCount DESC
LIMIT 500;

SELECT *
FROM tmp_film_actors
LIMIT 500;

# to samo tylko z CTE (common table expression)

WITH cte AS (SELECT fa.film_id, COUNT(fa.actor_id) AS ActorsCount
             FROM film_actor fa
             GROUP BY 1)
SELECT fl.film_id,
       fl.title,
       c.ActorsCount
FROM film fl
JOIN cte c ON c.film_id = fl.film_id
LIMIT 500;


# id filmu,
# tytuł filmu,
# liczbę wypożyczeń filmu.
# Wyniki zapisz do tabeli tymczasowej, np. tmp_film_rentals.

CREATE TEMPORARY TABLE tmp_film_rentals
AS
SELECT fl.film_id,
       fl.title,
       COUNT(ren.rental_id) AS RentalCount
FROM film fl
LEFT JOIN inventory inv ON fl.film_id = inv.film_id
LEFT JOIN rental ren ON inv.inventory_id = ren.inventory_id
GROUP BY fl.film_id
ORDER BY RentalCount
LIMIT 500;

DROP TEMPORARY TABLE tmp_film_rentals;

SELECT *
FROM tmp_film_rentals
LIMIT 500;


# Napisz zapytanie, które zwróci kwotę wpłat z filmu w następującym formacie:
#
# id filmu,
# kwota wpłat z filmu.
# Wyniki zapisz do tabeli tymczasowej, np. tmp_film_payments.

CREATE TEMPORARY TABLE tmp_film_payments
AS
SELECT inv.film_id, inv.inventory_id, SUM(p.amount) AS Amount
FROM payment as p
         INNER JOIN rental as ren USING (rental_id)
INNER JOIN inventory as inv USING (inventory_id)
GROUP BY inv.inventory_id;

DROP TEMPORARY TABLE tmp_film_payments;

SELECT *
FROM tmp_film_payments;



# Przygotuj raport, który wyświetli top 10 najchętniej wypożyczanych filmów.
# Przyjmij następujące założenia biznesowe do przygotowania raportu:
#
# nazwa filmu,
# liczba aktorów, którzy w nim grali,
# kwota przychodu filmu,
# liczba wypożyczeń filmu.

SELECT tfa.title,
       tfa.ActorsCount,
       tfp.Amount,
       tfr.RentalCount
FROM tmp_film_rentals tfr
JOIN tmp_film_actors tfa on tfr.film_id = tfa.film_id
JOIN tmp_film_payments tfp on tfa.film_id = tfp.film_id
ORDER BY tfp.Amount
LIMIT 10;


# Napisz zapytanie, które wygeneruje raport o:
#
# sumie sprzedaży danego sklepu oraz jego pracownikach,
# całkowitej sumie sprzedaży danego sklepu (bez podziału na pracowników),
# całkowitej sumie sprzedaży.

SELECT s.store_id,
       pt.staff_id,
       SUM(pt.amount) AS Sales
FROM payment pt
JOIN staff s on pt.staff_id = s.staff_id
GROUP BY s.store_id, pt.staff_id
WITH ROLLUP
ORDER BY 1, 2;


SELECT *
FROM store
LIMIT 500;

# Na podstawie tabeli payment napisz zapytanie, które:
#
# wyznaczy sumę wpłat w podziale na klienta oraz pracownika,
# wyznaczy sumę wpłat per klient,
# wyznaczy sumę wpłat.

SELECT pt.customer_id,
       pt.staff_id,
       SUM(pt.amount) AS Total
FROM payment pt
WHERE pt.customer_id < 4
GROUP BY pt.customer_id, pt.staff_id
WITH ROLLUP
# HAVING Total > 70
ORDER BY 1, 2;
# LIMIT 3;

#
# SELECT *
# FROM payment
# WHERE customer_id = 1
# LIMIT 500;




# Just for fun
SELECT (SELECT SHA1('12345') = (SELECT password FROM staff WHERE staff_id = 1));