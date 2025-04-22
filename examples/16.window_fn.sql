SELECT cust.customer_id,
       SUM(pt.amount)                                   AS TotalCustomerAmount,
       ROW_NUMBER() OVER (ORDER BY SUM(pt.amount) DESC) AS customer_rank,
       SUM(SUM(pt.amount)) OVER ()                      AS TotalAmount
FROM customer cust
         JOIN payment pt ON cust.customer_id = pt.customer_id
GROUP BY cust.customer_id
# ORDER BY TotalAmount DESC
LIMIT 500;


# RANK(), DENSE_RANK(), ROW_NUMBER(), LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE(), SUM(), AVG(), COUNT()

# window_fn(...) OVER ([PARTITION BY cols] [ORDER BY cols] [ROWS BETWEEN])

# ile wydał miesięcznie + różnica względem poprzedniego miesiąca

SELECT cust.customer_id,
       DATE_FORMAT(pt.payment_date, '%Y-%m')                                                                    AS month,
       SUM(pt.amount)                                                                                           AS amount_month,
       SUM(pt.amount) - LAG(SUM(pt.amount))
                            OVER (PARTITION BY cust.customer_id ORDER BY DATE_FORMAT(pt.payment_date, '%Y-%m')) AS diff_from_prev_month
FROM customer cust
         JOIN payment pt ON cust.customer_id = pt.customer_id
GROUP BY cust.customer_id, month
LIMIT 500;


# top 3 filmy z każdej kategorii (category_name, film_title, rental_count, ranking)


WITH film_rental_counts AS (SELECT cat.name                                                                            AS CategoryName,
                                   fl.title                                                                            AS FilmTitle,
                                   COUNT(ren.rental_id)                                                                AS RentalCount,
                                   ROW_NUMBER() OVER (PARTITION BY cat.category_id ORDER BY COUNT(ren.rental_id) DESC) AS ranking
                            FROM rental ren
                                     JOIN inventory inv ON ren.inventory_id = inv.inventory_id
                                     JOIN film fl ON inv.film_id = fl.film_id
                                     JOIN film_category fc ON fl.film_id = fc.film_id
                                     JOIN category cat ON fc.category_id = cat.category_id
                            GROUP BY cat.category_id, fl.film_id)

SELECT frc.CategoryName,
       frc.FilmTitle,
       frc.RentalCount,
       frc.ranking
FROM film_rental_counts frc
WHERE frc.ranking <= 3
ORDER BY frc.CategoryName, frc.ranking;


# Używając ROW_NUMBER oraz odpowiednich funkcji dat, stwórz w bazie danych tabelę calendar, która:
#
# będzie zaczynała się od '2000-01-01',
# skończy się na dacie '2030-12-31'.
# W tabeli kalendarza powinny znaleźć się następujące kolumny:
#
# data (date),
# rok (date_year),
# miesiąc (date_month),
# dzień (date_day),
# numer dnia tygodnia (day_of_week),
# numer tygodnia w roku (week_of_year),
# data wygenerowania kalendarza (last_update).

SET @date_range = DATEDIFF('2030-12-31', '2000-01-01');

SELECT @date_range;

WITH cte AS (SELECT ADDDATE('2000-01-01', (ROW_NUMBER() OVER ()) - 1) AS date
             FROM payment
             LIMIT 11323)
SELECT date,
       EXTRACT(year from date)  AS dateYear,
       EXTRACT(month from date) AS dateMont,
       EXTRACT(day from date)   AS dateDay,
       DAYOFWEEK(date)          AS dayOfWeek,
       WEEKOFYEAR(date)         AS weekOfYear,
       NOW()                    AS last_update
FROM cte
LIMIT 500;


SELECT *
FROM actor_analytics
LIMIT 500;


# Używając tabeli actor_analytics, napisz zapytanie, które pogrupuje aktorów według poniższych kryteriów:
#
# jeśli avg_film_rate < 2 - 'poor acting',
# jeśli avg_film_rate jest pomiędzy 2 oraz 2.5 - 'fair acting',
# jeśli avg_film_rate jest pomiędzy 2.5 oraz 3.5 - 'good acting',
# jeśli avg_film_rate jest powyżej 3.5 - 'superb acting'.
# Tak stworzoną kolumnę nazwij acting_level i następnie na jej podstawie dokonaj następującej analizy, obliczając:
#
# liczbę wystąpień w każdej grupie,
# sumę przychodów każdej grupy,
# liczbę filmów w każdej grupie,
# średni rating w grupie.

SELECT CASE
           WHEN avg_film_rate < 2 THEN 'poor acting'
           WHEN avg_film_rate BETWEEN 2 AND 2.5 THEN 'fair acting'
           WHEN avg_film_rate BETWEEN 2.5 AND 3.5 THEN 'good acting'
           WHEN avg_film_rate > 3.5 THEN 'super acting'
           ELSE 'error' END AS actingLevel,
       COUNT(actor_id)      AS countActors,
       SUM(actor_payload),
       SUM(films_amount),
       AVG(avg_film_rate)
FROM actor_analytics
GROUP BY actingLevel
LIMIT 500;


# Napisz kwerendę, która stworzy ranking aktorów na podstawie średniego ratingu z filmów, w których grali.

SELECT *,
       RANK() OVER (ORDER BY avg_film_rate DESC)
FROM actor_analytics
LIMIT 500;

# MIN dla avg_film_rate,
# SUM dla actor_payload,
# MAX dla longest_movie_duration.
# Jako klucza do sortowania użyj actor_id – rosnąco.

SELECT actor_id,
       avg_film_rate,
       actor_payload,
       longest_movie_duration,
       MIN(avg_film_rate) OVER (_order)          AS MinCum,
       SUM(actor_payload) OVER (_order)          AS SumCum,
       MAX(longest_movie_duration) OVER (_order) AS MaxCum
FROM actor_analytics
WINDOW _order AS (ORDER BY actor_id)
LIMIT 500;

# zbadamy jaki % aktorów odpowiada za jaki % wpływów wypożyczalni

SELECT actor_id,
       actor_payload,
       (ROW_NUMBER() OVER (payload) / COUNT(1) OVER ()) AS count_percent,
       (ROW_NUMBER() OVER (payload))             AS count_percent2,
       COUNT(42) OVER () AS count_percent3,

       SUM(actor_payload) OVER (payload) / SUM(actor_payload) OVER ()
FROM actor_analytics
WINDOW payload AS (ORDER BY actor_payload DESC);
