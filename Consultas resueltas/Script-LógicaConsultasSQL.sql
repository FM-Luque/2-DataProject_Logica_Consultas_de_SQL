
-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

SELECT f."title" AS "titulos", f."rating" AS "clasificacion_edades"
FROM "film" f 
WHERE f."rating" = 'R';

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40. 

SELECT 
 CONCAT(a."first_name",' ', a."last_name") AS "nombre_actor",
 a.actor_id 
 FROM actor a
WHERE a."actor_id" BETWEEN 30 AND 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.

SELECT f."title" AS "titulos", f."language_id" AS "idioma", f."original_language_id" AS "idio-ma_original"
FROM "film" f
WHERE f."film_id" = f."original_language_id";

--5. Ordena las películas por duración de forma ascendente.

SELECT f."title" AS "titulo", f."length" AS "duración"
FROM "film" f 
ORDER BY f."length" ASC;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
/*Nota como ‘Allen’ no viene aparece ninguno, he usado ‘ALLEN’*/

SELECT CONCAT(a."first_name",' ', a."last_name") AS "nombre_apellidos"  
FROM "actor" a
WHERE a."last_name" = 'ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

SELECT f.rating, COUNT(*)
FROM film f
GROUP BY f."rating" ; 

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film. 

SELECT f.title , f.rating ,f.length 
FROM film f
WHERE f.rating = 'PG-13' OR f.length > '180';


--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT 
ROUND(VARIANCE(f.replacement_cost),2) AS "coste_reemplazar_peliculas"
FROM film f;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

SELECT 
    MAX(length) AS mayor_duracion,
    MIN(length) AS menor_duracion
FROM film f;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT p.amount AS "coste", p.payment_date AS "fecha_pago"
FROM payment p 
ORDER BY p.payment_date DESC
LIMIT 3
;

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
SELECT f.title , f.rating 
FROM film f 
WHERE f.rating NOT IN ('NC-17','G');

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT 
f.rating AS "clasificacion",
ROUND(AVG (DISTINCT (f.length )),2) AS "promedio_duracion"
FROM film f
GROUP BY f.rating ;

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT f.title AS "titulo" , length AS "duración_mayor_180"
FROM film f 
WHERE f.length > 180
ORDER BY f.length;


--15. ¿Cuánto dinero ha generado en total la empresa?

SELECT 
	SUM(p.amount)
FROM payment p ;

--16. Muestra los 10 clientes con mayor valor de id.
SELECT 
	c.customer_id ,
	CONCAT(c.first_name,' ',c.last_name) AS "nombre_apellidos"
FROM customer c  
ORDER BY customer_id DESC
LIMIT 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

SELECT a.first_name , a.last_name , f.title
FROM actor a 
RIGHT JOIN  film f 
ON a.actor_id  = f.film_id 
WHERE f.title  = 'EGG IGBY';

--18. Selecciona todos los nombres de las películas únicos.

SELECT 
	DISTINCT (f.title ) AS "nombres_film_unicos"
FROM film f
WHERE F.title IS NOT NULL;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

SELECT f.title AS "titulo" , f.length AS "duración",c."name" AS "ca-tegoria"
FROM film f 
RIGHT JOIN category c 
ON f.film_id = c.category_id 
WHERE c."name" = 'Comedy' AND f.length > 180;

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT 
f.rating AS "categorias",
ROUND(AVG (DISTINCT (f.length )),0) AS "promedio_duracion"
FROM film f
GROUP BY f.rating 
HAVING AVG(f.length ) > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?   

SELECT  ROUND(AVG(f.rental_duration ),0)
FROM film f ;


--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT 
	CONCAT(a.first_name,' ',a.last_name) AS "nombre_apellidos"
FROM actor a 
ORDER BY "nombre_apellidos";

--23. Números de alquiler por día, ordenados por cantidad de alquiler de  forma descendente.

SELECT EXTRACT (DAY FROM "rental_date") AS "dia_alquiler",
COUNT("rental_date") AS "cantidad_alquileres"
FROM "rental" r 
GROUP BY (EXTRACT (DAY FROM "rental_date"))
ORDER BY (EXTRACT (DAY FROM "rental_date")) DESC;

-- 24. Encuentra las películas con una duración superior al promedio. ok

SELECT f.title, f.length
FROM film f 
	WHERE f.length > 
	(SELECT AVG(f2.length ) FROM film f2 
	)
ORDER BY f.length;


-- 25. Averigua el número de alquileres registrados por mes.

SELECT EXTRACT (MONTH FROM "rental_date") AS "mes_alquiler",
COUNT(DISTINCT("rental_date")) AS "cantidad_alquileres"
FROM "rental" r 
GROUP BY (EXTRACT (MONTH FROM "rental_date"))
ORDER BY (EXTRACT (MONTH FROM "rental_date"));


--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT 
ROUND(AVG(p."amount"),2) AS "promedio",
ROUND(STDDEV(p."amount"),2) AS "desviacion_estandar",
ROUND(VARIANCE(p."amount"),2) AS "varianza",
SUM(p."amount") AS "total_pagado",
COUNT(p."amount") AS "total_operaciones"
FROM "payment" p ;


-- 27. ¿Qué películas se alquilan por encima del precio medio? 

SELECT f.title AS "titulo", f.rental_rate AS "precio_pelicula"
FROM film f 
	WHERE f.rental_rate >
	(SELECT AVG(f2.rental_rate ) FROM film f2 
	)
ORDER BY F.rental_rate;

--28. Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT fa.actor_id ,
COUNT(f.title)
FROM film f 
RIGHT  JOIN film_actor fa 
ON f.film_id = fa.film_id 
GROUP BY fa.actor_id 
HAVING COUNT(f.title) > 40;


--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
/*Nota: DISPONIBLE 2 en i.store.id */

SELECT f.title AS "titulo", 
COUNT(i.store_id) AS "pelicula_disponible"
FROM inventory i 
INNER JOIN film f 
ON f.film_id = i.film_id 
WHERE i.store_id = 2 
GROUP BY f.title
ORDER BY f.title ;

--30. Obtener los actores y el número de películas en las que ha actuado.

SELECT 
fa.actor_id AS "Actor", 
concat(a.first_name ,' ',a.last_name ) AS "nombre_actor",
count(f.film_id) AS "nº_peliculas"
FROM film_actor fa
INNER JOIN film f ON fa.film_id = f.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id 
GROUP BY fa.actor_id , "nombre_actor"
ORDER BY "nombre_actor";

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

SELECT
f.title,
CONCAT(a.first_name,' ',a.last_name  )
FROM film f 
LEFT JOIN actor a 
ON f.film_id = a.actor_id;


--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

SELECT
CONCAT(a.first_name,' ',a.last_name  ),
f.title
FROM film f 
LEFT JOIN actor a 
ON f.film_id = a.actor_id;


--33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT f.title,
r.rental_id ,r.rental_date ,r.inventory_id ,r.customer_id ,r.return_date ,r.staff_id
FROM film f 
LEFT JOIN rental r 
ON f.film_id = r.inventory_id
ORDER BY F.title ;

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT concat(c.first_name,' ',c.last_name) AS "clientes",
sum(p.amount )
FROM customer c 
LEFT JOIN payment p 
ON c.customer_id  = p.customer_id 
group BY "clientes" 
ORDER BY sum(p.amount ) DESC
LIMIT 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT a.actor_id ,a.first_name ,a.last_name 
FROM actor a  
WHERE a.first_name = 'JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

SELECT 
a.actor_id ,
a.first_name AS "Nombre" ,
a.last_name AS "Apellido"
FROM actor a  
WHERE a.first_name = 'JOHNNY';

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT 
max(a.actor_id) AS "id_mas_alto" ,
min(a.actor_id) AS "id_mas_bajo"
FROM actor a ; 


--38. Cuenta cuántos actores hay en la tabla “actor”.

SELECT 
count(a.actor_id) 
FROM actor a ; 


--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT 
a.last_name AS "Apellido",
a.first_name AS "Nombre"
FROM actor a 
ORDER BY "Apellido";

--40. Selecciona las primeras 5 películas de la tabla “film”.

SELECT 
f.title 
FROM film f
ORDER BY title 
LIMIT 5;


--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

SELECT a.first_name AS "nombre",
count(a.first_name) AS "nº_actor_mismo_nombre"
FROM actor a 
GROUP BY a.first_name
ORDER BY a.first_name ;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT count(r.rental_id) AS "total_alquileres",
concat(c.first_name,' ',c.last_name) AS "clientes"
FROM rental r  
LEFT JOIN customer c 
ON r.customer_id  = c.customer_id 
group BY "clientes";

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT concat(c.first_name,' ',c.last_name) AS "clientes",
count(r.rental_id ) AS "total_alquileres"
FROM rental r  
LEFT JOIN customer c 
ON r.customer_id  = c.customer_id 
group BY "clientes" ;


--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
/* NO. En mi opinión no aporta una información clara, al combirar todas las opciones */

SELECT *
FROM film f 
CROSS JOIN customer c ;


--45. Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT  concat(a.first_name ,' ', a.last_name ) AS "nombre_actor", c."name" 
FROM actor a 
LEFT   JOIN category c 
ON a.actor_id = c.category_id 
WHERE c."name" = 'Action';


--46. Encuentra todos los actores que no han participado en películas.


SELECT  concat(a.first_name ,' ', a.last_name ) AS "nombre_actor", c."name" 
FROM actor a 
LEFT  JOIN category c 
ON a.actor_id = c.category_id 
WHERE c."name" IS NULL;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT  
	CONCAT(a.first_name ,' ', a.last_name ) AS "nombre_actor", 
	COUNT(fa.film_id) AS "total_peliculas"
FROM actor a 
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY "nombre_actor"
ORDER BY "nombre_actor";

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado. 

CREATE VIEW v_actor_num_peliculas AS
SELECT  
	CONCAT(a.first_name ,' ', a.last_name ) AS "nombre_actor", 
	COUNT(fa.film_id) AS "total_peliculas"
FROM actor a 
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY "nombre_actor"
ORDER BY "nombre_actor";

--49. Calcula el número total de alquileres realizados por cada cliente. OK

SELECT count(r.rental_id) AS "total_alquileres",
concat(c.first_name,' ',c.last_name) AS "clientes"
FROM rental r  
LEFT JOIN customer c 
ON r.customer_id  = c.customer_id 
group BY "clientes"
 
/* Otra opción */

SELECT concat(c.first_name,' ',c.last_name) AS "clientes",
	(SELECT count(r.rental_id) FROM rental r 
	WHERE 	c.customer_id = r.customer_id ) AS "Total Alquieres"
FROM customer c 
ORDER BY "clientes";

--50. Calcula la duración total de las películas en la categoría 'Action'.  

SELECT  sum(f.length ) AS "duracion_total"
FROM film f 
LEFT JOIN film_category fc ON f.film_id = fc.category_id 
LEFT JOIN category c ON fc.category_id  = c.category_id 
WHERE c."name" = 'Action';



--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

WITH cliente_rentas_temporal AS 
(SELECT 
	concat(c.first_name,' ',c.last_name) AS "clientes",
	count(r.rental_id) AS "total_alquileres"
FROM rental r  
LEFT JOIN customer c ON r.customer_id  = c.customer_id 
group BY "clientes")
SELECT *
FROM cliente_rentas_temporal ;



--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

WITH peliculas_alquiladas AS 
(SELECT f.film_id,  F.title,
	f.rental_duration  AS "total_alquileres"
FROM film f
ORDER BY f.film_id )
SELECT *
FROM peliculas_alquiladas
WHERE "total_alquileres" > 10;


--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

WITH TAMMYNoReturn AS (
SELECT c.customer_id ,concat(c.first_name,' ',c.last_name) AS nombre,r.return_date  AS fechadevolucion
FROM customer c
JOIN rental r ON c.customer_id =r.customer_id 
GROUP BY c.customer_id ,c.first_name,r.return_date
HAVING r.return_date IS NULL AND concat(c.first_name,' ',c.last_name) = 'TAMMY SANDERS'
),
titulopelicula AS (
SELECT f.film_id ,f.title AS titulo
FROM film f )
SELECT nombre,titulo,fechadevolucion
FROM TAMMYNoReturn
JOIN titulopelicula ON TAMMYNoReturn.customer_id  = titulopelicula.film_id 
ORDER BY nombre
;


--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.

SELECT DISTINCT concat(A.first_name ,' ',A.last_name ) AS "Actor"
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id 
JOIN  film f ON FA.actor_id = f.film_id 
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON fc.film_id = c.category_id 
WHERE c."name" = 'Sci-Fi';

--- Otra opción ---

SELECT concat(a.first_name ,' ',a.last_name ) AS "Actor"
FROM actor a 
WHERE a.actor_id IN (  
	SELECT  c.category_id
	FROM category c   
	WHERE c."name" = 'Sci-Fi')
	ORDER BY a.last_name ;


--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido. 

SELECT a.first_name ,a.last_name,f.title,r.rental_date
FROM  actor a 
FULL JOIN film_actor fa  ON a.actor_id  = fa.actor_id  
FULL JOIN film f ON fa.actor_id = f.film_id 
FULL JOIN inventory i  ON f.film_id  = i.film_id 
FULL JOIN rental r  ON i.film_id   = r.rental_id 
WHERE r.rental_date > (SELECT Min(r2.rental_date) FROM rental r2)
GROUP BY a.first_name ,a.last_name,f.title,r.rental_date
HAVING f.title <> 'SPARTACUS CHEAPER'
ORDER BY a.last_name;



--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

SELECT concat(a.first_name ,' ',a.last_name ) AS "Actor"
FROM actor a 
WHERE a.actor_id IN (  
	SELECT  c.category_id
	FROM category c   
	WHERE c."name" <> 'Music')
	ORDER BY "Actor" ;


--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT f.title 
FROM film f 
WHERE f.rental_duration > 8 ;


--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.

SELECT f.title 
FROM film f 
INNER JOIN category c ON f.film_id   = c.category_id 
WHERE c."name" = 'Animation';



--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película. 'DANCING FEVER'

SELECT f.title 
FROM film f
WHERE f.length  =
	(SELECT  f2.length 
	FROM film f2 
	WHERE f2.title = 'DANCING FEVER')
ORDER BY f.title; 


--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

SELECT c.first_name , c.last_name  
FROM customer c  
WHERE c.customer_id in
	(SELECT COUNT(P.customer_id )
	FROM payment p 
	WHERE P.customer_id >= 7 AND 
	GROUP BY P.customer_id)
ORDER BY c.last_name;


--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c."name", COUNT(r.rental_id ) AS "total_peliculas_alquiladas"
FROM category c 
INNER JOIN film_category fc ON c.category_id = fc.category_id 
INNER JOIN film f ON fc.category_id = F.film_id 
INNER JOIN inventory i  ON F.film_id  = i.film_id 
INNER JOIN rental r  ON i.film_id   = r.rental_id 
GROUP BY c.category_id, c."name";


--62. Encuentra el número de películas por categoría estrenadas en 2006. OK

SELECT c.name AS "nombre categoria",COUNT(f.film_id )  
FROM film f 
	JOIN film_category fc ON f.film_id = fc.category_id 
	JOIN category c ON fc.category_id = c.category_id 
	WHERE CAST(f.release_year AS CHAR(4)) = '2006'
	GROUP BY "nombre categoria";



--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos. OK

SELECT *
FROM staff s 
CROSS JOIN address a 
CROSS JOIN city c
CROSS JOIN country c2 ;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas. OK

SELECT c.customer_id, concat(c.first_name,' ',c.last_name) AS "clien-tes",
	(SELECT count(r.rental_id) FROM rental r 
	WHERE 	c.customer_id = r.customer_id ) AS "Total Alquieres"
FROM customer c 
ORDER BY c.customer_id,"clientes";

--- Otra opicón  ----

SELECT
c.customer_id ,
concat(c.first_name,' ',c.last_name) AS "clientes",
count(r.rental_id) AS "total_alquileres"
FROM rental r  
LEFT JOIN customer c 
ON r.customer_id  = c.customer_id 
group BY c.customer_id ,"clientes"
ORDER BY c.customer_id, "clientes" ;


