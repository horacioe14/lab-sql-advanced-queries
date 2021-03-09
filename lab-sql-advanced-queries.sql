# Instructions
#1. List each pair of actors that have worked together.
use sakila;
with cte_film_actor as (select actor_id, film_id from sakila.film_actor),
cte_film_actor2 as (select actor_id, film_id from sakila.film_actor)
select a1.actor_id, a1.film_id, a2.actor_id
from cte_film_actor a1
join cte_film_actor2 a2
on a1.actor_id <> a2.actor_id
and a1.film_id = a2.film_id
order by a1.film_id;



select fa1.film_id, a1.actor_id, concat(a1.first_name,' ',a1.last_name) as Actor1, 
a4.actor_id, concat(a4.first_name,' ',a4.last_name) as Actor2
from sakila.actor a1
join sakila.film_actor fa1
on a1.actor_id = fa1.actor_id
join sakila.film_actor fa2
on fa2.film_id=fa1.film_id 
and fa2.actor_id <> fa1.actor_id
join sakila.actor a4
on a4.actor_id=fa2.actor_id
order by fa1.film_id, a1.actor_id, concat(a1.first_name,' ',a1.last_name), a4.actor_id, concat(a4.first_name,' ',a4.last_name);


#2. For each film, list actor that has acted in more films.
select * from (
	select *, row_number() over (partition by film_id order by total desc) ranking
	from (
		select film_id, actor_id, count(film_id) as total from sakila.film_actor
		group by actor_id, film_id
		order by total
		) as sub1
	) as sub2
where ranking = 1;

select fa.actor_id, a.first_name, a.last_name, count(fa.film_id) as films_acted
from sakila.film_actor as fa
join sakila.actor as a
on fa.actor_id = a.actor_id
group by fa.actor_id, a.first_name
order by films_acted desc;

select actor_id, film_id
from sakila.film_actor
group by actor_id, film_id
order by actor_id asc;

select film_id, actor_id
from sakila.film_actor
group by film_id, actor_id;
use sakila;
with cte_number_of_films as
(
   select actor_id, count(film_id) as films_acted
   from sakila.film_actor
   group by actor_id
   order by films_acted desc
), 
cte_ranking as 
(
	select film_id, actor_id, films_acted, 
    row_number() over (partition by film_id order by films_acted desc) as Ranking
	from film_actor
	join cte_number_of_films using (actor_id)
) 
select film_id, title, concat(a.first_name,' ', a.last_name) as actor_name, films_acted 
from cte_ranking
join actor as a using (actor_id)
join film as f using (film_id)
where Ranking = 1;


select f.film_id, f.title, fa.actor_id
from sakila.film as f 
join sakila.film_actor as fa
on f.film_id = fa.film_id
where fa.actor_id = 107
group by f.film_id, f.title, fa.actor_id;


select f.film_id, f.title, a.actor_id, concat(a.first_name, ' ', a.last_name) as actor_name
from sakila.film as f
join sakila.film_actor as fa
on f.film_id = fa.film_id
join sakila.actor as a
on a.actor_id = fa.actor_id
where a.actor_id = (  #select only actor_id in subquery. Use =  instead of in
    select actor_id from (
    select a.actor_id, count(fa.film_id) as films_acted
    from sakila.film_actor as fa
    join sakila.actor as a
    on fa.actor_id = a.actor_id
    group by fa.actor_id, a.first_name
    order by films_acted desc
    limit 1) sub1
);

