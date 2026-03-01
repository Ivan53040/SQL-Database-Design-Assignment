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