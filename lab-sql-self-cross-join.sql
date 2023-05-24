USE sakila;

# 1. Get all pairs of actors that worked together.
SELECT CONCAT(a1.first_name, ' ', a1.last_name) AS `actor1_name`, 
	   CONCAT(a2.first_name, ' ', a2.last_name) AS `actor2_name`, 
       title AS film_title
FROM actor AS a1                                     
JOIN film_actor AS fa1 ON a1.actor_id = fa1.actor_id
JOIN film AS f ON fa1.film_id = f.film_id
JOIN film_actor AS fa2 ON f.film_id = fa2.film_id
JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
WHERE a1.actor_id < a2.actor_id
ORDER BY 3;

# 2. Get all pairs of customers that have rented the same film more than 3 times.
-- In one query:
SELECT CONCAT(c1.first_name, ' ', c1.last_name) AS customer1_name,
       CONCAT(c2.first_name, ' ', c2.last_name) AS customer2_name,
       COUNT(*) AS number_of_films
FROM customer AS c1
JOIN rental AS r1 ON c1.customer_id = r1.customer_id
JOIN inventory AS i1 ON i1.inventory_id = r1.inventory_id
JOIN film AS f ON f.film_id = i1.film_id
JOIN inventory AS i2 ON i2.film_id = f.film_id
JOIN rental AS r2 ON r2.inventory_id = i2.inventory_id
JOIN customer AS c2 ON c2.customer_id = r2.customer_id
WHERE c1.customer_id <> c2.customer_id
GROUP BY customer1_name, customer2_name
HAVING COUNT(*) > 3
ORDER BY 1,2;

-- With temporary tables:
CREATE TEMPORARY TABLE client1
SELECT CONCAT(first_name, ' ', last_name) AS `name`, r.customer_id, r.inventory_id, i.film_id, f.title
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id;

CREATE TEMPORARY TABLE client2
SELECT CONCAT(first_name, ' ', last_name) AS `name`, r.customer_id, r.inventory_id, i.film_id, f.title
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id;

SELECT c1.customer_id, c2.customer_id, COUNT(*) AS coincidences FROM client1 AS c1
JOIN client2 AS c2 ON c1.film_id = c2.film_id
WHERE c1.customer_id <> c2.customer_id
GROUP BY 1, 2
HAVING coincidences > 3
ORDER BY c1.customer_id, c2.customer_id;

# 3. Get all possible pairs of actors and films.
SELECT a.actor_id, a.first_name, f.title
FROM actor AS a
CROSS JOIN film AS f
order by 1,3;
