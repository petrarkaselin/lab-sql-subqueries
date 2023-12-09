# LAB | SQL Subqueries
use sakila;

## Challenge

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
select count(inventory_id), title from (
SELECT inventory_id, title FROM inventory as i
left JOIN film as f
ON i.film_id = f.film_id
where title = "Hunchback Impossible") as sub;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
select round(avg(length), 2) from film;

select * from film
where length > (
select round(avg(length), 2)
from film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
select title, first_name, last_name from
(select actor_id, film_id, title, first_name, last_name 
from film as f
left join film_actor as fa
using (film_id)
left join actor as a
using (actor_id)) as sub
where title = "Alone Trip";

## Bonus**:

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
	-- Identify all movies categorized as family films. 
select film, category from
(select title as film, name as category 
from film as f
left join film_category as fc
using (film_id)
left join category as c
using (category_id)) as sub
where category = 'family';

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
	-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
select name, email, country from
(select last_name as name, email, address_id, city_id, country_id, country
from customer as cus
left join address as ad
using (address_id)
left join city as cit
using (city_id)
left join country as cou
using (country_id)) as sub
where country = 'CANADA'; 

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
	-- A prolific actor is defined as the actor who has acted in the most number of films. 
	-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
select prolific_actor, count(prolific_actor) as number_of_films
from 
(select concat(first_name, ' ', last_name) as prolific_actor, title as film 
from actor
left join film_actor
using (actor_id)
left join film
using (film_id)
) as sub
group by prolific_actor
order by number_of_films desc
limit 1;

-- 7. Find the films rented by the most profitable customer in the Sakila database. 
	-- You can use the customer and payment tables to find the most profitable customer, 
	-- i.e., the customer who has made the largest sum of payments.
 select customer_id, customer, title
 from film 
 left join inventory
 using (film_id)
 left join rental
 using(inventory_id)
 right join 
 (select customer_id, customer, sum(amount) as payments
 from
 (select customer_id, concat(first_name, ' ', last_name) as customer, amount
 from payment
 left join customer
 using(customer_id))
 as sub
 group by customer_id, customer, amount
  order by payments desc
  limit 5) as sub
  using (customer_id)
; 
-- subquery the most profitable customer
select customer_id, customer, sum(amount) as payments
 from
 (select customer_id, concat(first_name, ' ', last_name) as customer, amount
 from payment
 left join customer
 using(customer_id))
 as sub
 group by customer_id, customer, amount
  order by payments desc
  limit 5;
 
-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
	-- You can use subqueries to accomplish this.
select customer_id, customer, sum(amount) as payments
 from
 (select customer_id, concat(first_name, ' ', last_name) as customer, amount
 from payment
 left join customer
 using(customer_id))
 as sub
 group by customer_id, customer, amount
 having sum(amount) > (
 SELECT AVG(payments) FROM (select customer_id, customer, sum(amount) as payments
 from
 (select customer_id, concat(first_name, ' ', last_name) as customer, amount
 from payment
 left join customer
 using(customer_id))
 as sub
 group by customer_id, customer, amount
) AS sub_avg)
order by payments desc;

-- the average of the total_amount spent by each client
SELECT AVG(payments) FROM (select customer_id, customer, sum(amount) as payments
 from
 (select customer_id, concat(first_name, ' ', last_name) as customer, amount
 from payment
 left join customer
 using(customer_id))
 as sub
 group by customer_id, customer, amount
) AS sub_avg;

  
  