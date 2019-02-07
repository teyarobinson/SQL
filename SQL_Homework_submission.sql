USE Sakila; 

#1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name 
FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT UPPER(CONCAT(first_name, " ", last_name)) AS 'Actor Namer'
FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

#2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name 
FROM actor
WHERE last_name LIKE  '%GEN%';

#2c. Find all actors whose last names contain the letters `LI`. 
#This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE  '%LI%'
ORDER BY last_name;

#2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country 
WHERE country IN ("Afghanistan", "Bangladesh", "China");

#3a. You want to keep a description of each actor. 
#You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` 
#(Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD description BLOB; 

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor 
DROP COLUMN  description; 

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT DISTINCT last_name AS "Last Name" , Count(DISTINCT last_name)
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name,
#but only for actor names that are shared by at least two actors
SELECT last_name, count(actor_id) AS "# of Actors w. LN"
FROM actor
GROUP BY last_name
HAVING count(actor_id)  > 1;


#4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" and last_name = "WILLIAMS";

#4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, 
#if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" and last_name = "WILLIAMS";

#5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address; 
  #Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)

#6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
 SELECT first_name, last_name, address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

#6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT Count(amount), staff.staff_id
FROM staff
INNER JOIN payment ON 
staff.staff_id = payment.staff_id
GROUP BY staff.staff_id ; 

#6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title, count(actor_id) AS "Number of Actors in Film"
FROM  film 
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
GROUP BY  film.film_id;

# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, count(film.film_id) as "Copies"
FROM film 
INNER JOIN inventory ON 
film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible"
GROUP BY film.film_id;

#6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name AS "First Name", c.last_name AS "Last Name" , count(p.amount) AS "Total Paid"
FROM customer c 
INNER JOIN payment p ON 
c.customer_id = p.customer_id 
GROUP BY c.customer_id
ORDER BY c.last_name ASC; 

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title
FROM film
WHERE film.title = "K%" OR "Q%" AND language_id IN 
(SELECT language_id
FROM language
WHERE language.name = "English" 
)
;

#7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name AS "first name", last_name AS "last name"
FROM actor
WHERE actor_id IN
(select actor_id
FROM film_actor
WHERE film_id IN
(select film_id
FROM film 
WHERE title = "Alone Trip"
)); 

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name as "first name", last_name as "last name", email
From customer 
WHERE address_id IN 
(select address_id 
from address
WHERE  city_id IN 
(select city_id 
from city 
WHERE country_id IN
(select country_id
from country 
where country = "canada"
))); 

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT title
FROM film
WHERE film_id IN
(select film_id 
from film_category
WHERE category_id IN
(select category_id 
from category 
WHERE  name = "family"
)); 

#7e. Display the most frequently rented movies in descending order.
SELECT  f.title, count(r.rental_id) AS Rented
FROM film f join inventory i on f.film_id = i.film_id join rental r on i.inventory_id = r.inventory_id
group by title
ORDER BY Rented DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) AS Revenue
FROM store s join staff st on s.manager_staff_id = st.staff_id join payment p on st.staff_id = p.staff_id
group by store_id; 

#7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city AS city, co.country as country
FROM country co join city c on co.country_id = c.country_id join address a on c.city_id = a.city_id  join store s on a.address_id = s.address_id
group by store_id;

#7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT SUM(p.amount) as GR, c.name as category
FROM category c join film_category fc on
c.category_id = fc.category_id join film f on
fc.film_id = f.film_id join inventory i on
f.film_id = i.film_id join rental r on
i.inventory_id = r.inventory_id join 
payment p on r.rental_id = p.rental_id
group by category
Order by GR desc 
limit 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_Grossing AS
SELECT SUM(p.amount) as GR, c.name as category
FROM category c join film_category fc on
c.category_id = fc.category_id join film f on
fc.film_id = f.film_id join inventory i on
f.film_id = i.film_id join rental r on
i.inventory_id = r.inventory_id join 
payment p on r.rental_id = p.rental_id
group by category
Order by GR desc 
limit 5; 

#8b. How would you display the view that you created in 8a?
SELECT * FROM Top_Grossing;

#8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW Top_Grossing;