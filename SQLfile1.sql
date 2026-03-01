--Q1.1
SELECT f.title
FROM film f 

JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON f.language_id = l.language_id
WHERE f.length < 50
AND l.name = 'English'
AND c.name = 'Comedy';

--Q1.2
SELECT distinct a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON f.language_id = l.language_id
WHERE f.length < 50
AND l.name = 'English'
AND c.name = 'Comedy';

--Q1.3
CREATE VIEW V_HR_MU_2010_ACTORS AS
SELECT distinct a.actor_id, a.first_name, a.last_name 
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.rental_rate > 4 
AND f.release_year > 2010 
AND c.name = 'Music';

--Q1.4
CREATE MATERIALIZED VIEW MV_HR_MU_2010_ACTORS AS
SELECT distinct a.actor_id, a.first_name, a.last_name 
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.rental_rate > 4 
AND f.release_year > 2010 
AND c.name = 'Music';

--Q2.1
SELECT title
FROM film
WHERE POSITION('Boat' IN description) > 0
ORDER BY title
LIMIT 10;

--Q2.2
CREATE INDEX IDX_BOAT
ON film ((POSITION('Boat' IN description)));

--Q2.3
EXPLAIN ANALYZE
SELECT title
FROM film
WHERE POSITION('Boat' IN description) > 0
ORDER BY title
LIMIT 10;

--Q3.1(A) using GROUP BY
SELECT SUM(cluster_size) AS film_count
FROM (
  SELECT COUNT(*)AS cluster_size
  FROM film
  GROUP BY release_year, rating, special_features
  HAVING COUNT(*) >=41
) temp;

--Q3.1(B) without using GROUP BY
SELECT COUNT (*) AS film_count
FROM film f
WHERE (
  SELECT COUNT(*)
  FROM film f2
  WHERE f2.release_year = f.release_year
  AND f2.rating = f.rating
  AND f2.special_features = f.special_features
) >=41;

--Q3.2
--create index
CREATE INDEX IDX_YEAR ON film (release_year);
CREATE INDEX IDX_RATE ON film (rating);
CREATE INDEX IDX_FEATURE ON film (special_features);

--analyze group by
EXPLAIN ANALYZE
SELECT SUM(cluster_size) AS film_count
FROM (
  SELECT COUNT(*)AS cluster_size
  FROM film
  GROUP BY release_year, rating, special_features
  HAVING COUNT(*) >=41
) AS temp;

--analyze without group by
EXPLAIN ANALYZE
SELECT COUNT (*) AS film_count
FROM film f
WHERE (
  SELECT COUNT(*)
  FROM film f2
  WHERE f2.release_year = f.release_year
  AND f2.rating = f.rating
  AND f2.special_features = f.special_features
) >=41;

--Q4.1.1
-- for film_id < 100
EXPLAIN ANALYZE 
SELECT * FROM film WHERE film_id < 100; 

-- for film_id >= 100
EXPLAIN ANALYZE 
SELECT * FROM film WHERE film_id >= 100;

--Q4.1.2
--with index scans enabled and sequential scans disabled
SET enable_seqscan = off;
-- for film_id < 100
EXPLAIN ANALYZE 
SELECT * FROM film WHERE film_id < 100; 

-- for film_id >= 100
EXPLAIN ANALYZE 
SELECT * FROM film WHERE film_id >= 100;

--Q4.1.3
--with sequential scans enabled and index scans disabled
SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;
SET enable_indexonlyscan = off;

-- for film_id < 100
EXPLAIN ANALYZE 
SELECT * FROM film WHERE film_id < 100; 

-- for film_id >= 100
EXPLAIN ANALYZE 
SELECT * FROM film WHERE film_id >= 100;