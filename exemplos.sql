-- Active: 1668736719451@@localhost@3306@classicmodels
SELECT productCode,
       COUNT(productName) AS contagem_produtos,
       COUNT(productScale) AS sca_count
FROM classicmodels.products
GROUP BY productCode
HAVING COUNT(productName) > 0
ORDER BY productCode DESC;

/* Posso ditar o modo de organização a cada campo (ASCENDENTE ou DESCENDENTE)
-- Ordem de execução: FROM, WHERE, SELECT, ORDER BY, LIMIT 
Ordem de execução (Com 'group by'): FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT*/

-- INNER JOIN

SELECT customers.country,
       customers.customerName,
       orders.orderNumber
FROM classicmodels.customers
INNER JOIN classicmodels.orders
USING(customerNumber); /* Uso se ambas as tabelas tem a coluna/chave com mesmo nome*/

-- Usando Alias

SELECT c.country AS nome_do_pais,
       c.customerName,
       o.orderNumber
FROM classicmodels.customers AS c
INNER JOIN classicmodels.orders AS o
ON c.customerNumber = o.customerNumber;


SELECT c.country,
       COUNT(o.orderNumber) AS numero_pedidos
FROM classicmodels.customers AS c
INNER JOIN classicmodels.orders AS o
USING(customerNumber)
GROUP BY country
HAVING COUNT(o.orderNumber) >= 30
ORDER BY numero_pedidos;

/* Multiplos Joins */

SELECT c.country AS nome_do_pais,
       c.customerName,
       o1.orderDate,
       o2.orderNumber,
       o2.quantityOrdered
FROM customers AS c
INNER JOIN classicmodels.orders AS o1
USING(customerNumber)
INNER JOIN classicmodels.orderdetails AS o2
USING(orderNumber);

/* Em JOINs multiplos, posso usar como chave colunas da tabela da direita usada no primeiro join, isso porque o segundo JOIN 
sera realizado já sobre o resultado do primeiro JOIN, ou seja, o filtro já estara aplicado. */

SELECT c.country AS nome_do_pais,
       c.customerName,
       o1.orderDate,
       o2.orderNumber,
       o2.quantityOrdered
FROM customers AS c
INNER JOIN classicmodels.orders AS o1
USING(customerNumber)
INNER JOIN classicmodels.orderdetails AS o2
USING(orderNumber)
WHERE c.creditLimit >= 50000;


SELECT name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
/* O SQL retorna todas as linhas com chave identica, as vezes é necessário adicionar outro filtro, como por data */
AND p.year = e.year;

-- LEFT JOIN

SELECT c.country AS nome_do_pais,
       c.customerName,
       o.orderDate
FROM customers AS c
LEFT JOIN orders AS o
USING(customerNumber);

-- RIGHT JOIN

SELECT c.country AS nome_do_pais,
       COUNT(o.orderNumber) AS quantidade_pedidos
FROM customers AS c
RIGHT JOIN orders AS o
USING(customerNumber)
GROUP BY c.country
ORDER BY nome_do_pais DESC
LIMIT 10;

-- FULL JOIN

SELECT c.country AS nome_do_pais,
       c.customerName,
       o.orderDate
FROM customers AS c
FULL JOIN orders AS o
ON c.customerNumbe = o.customerNumber; /* Traz todos os paises que tenham consumidor ou algum pedido ou ambos (consumidor e pedido) */
/* FULL JOIN não é suportado pelo MYSQL */

-- CROSS JOIN

SELECT c.country AS nome_do_pais,
       p.productName
FROM customers AS c
CROSS JOIN products AS p
WHERE c.country IN('USA', 'France')
ORDER BY nome_do_pais; /* Retorna todas AS combinações possíveis de País e Produto para USA e França */
/* Retorna todas AS combinações de duas amostras de dados */
/* Pode retornar valores duplicados em casos em que se tenha o mesmo campo B para dois campos A. 
 * Por exemplo, se o haver o mesmo numero de ordem para dois Paises distintos. Dependendo do contexto de Análise, é necessário tratar isso. */

-- SUBQUERIES

/*Primeiro, seleciono países cuja região é o "Middle East"   */
SELECT code
FROM countries
WHERE region = 'Middle East';

/*Uso essa query como filtro em outra query, essa query aninhada é uma subquerie conhecida como semi-join - um filtro baseado em outra consulta*/
SELECT DISTINCT languages.name
FROM languages
-- Add syntax to use bracketed subquery below as a filter
WHERE code IN
            (SELECT code
            FROM countries
            WHERE region = 'Middle East')
ORDER BY languages.name;

-- Posso buscar onde "NÃO HÁ" a condição, consulta chamada de anti-join.
SELECT code, country_name
FROM countries
WHERE continent = 'Oceania'
-- Filter for countries not included in the bracketed subquery
AND code NOT IN
    (SELECT code
    FROM currencies
    WHERE continent = 'Oceania');

/* Posso usar semijoin para diagnosticar/conferir joins*/
SELECT c1.code, c1.country_name, c2.basic_unit AS currency
FROM countries AS c1
INNER JOIN currencies AS c2
ON c1.code = c2.code
WHERE c1.continent = 'Oceania';

--Subqueries no "WHERE" podem ser referir a mesma tabela ou outra tabela.ADD

/*Uso SQL e subqueries para fazer consultas com base em cálculos */
-- A saída da subquery tem de ser o mesmo tipo de dado do filtro que utilizo
SELECT *
FROM populations
-- Filter for only those populations where life expectancy is 1.15 times higher than average
WHERE life_expectancy > 1.15 * 
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015) 
	 AND year = 2015;


-- Select relevant fields from cities table
SELECT 
      cities.name,
      country_code,
      urbanarea_pop
FROM cities
-- Filter using a subquery on the countries table
WHERE cities.name IN
             (SELECT
                    capital
              FROM countries)
ORDER BY urbanarea_pop DESC;


/* Subqueries no 'SELECT' podem substituir JOINs */

SELECT countries.country_name AS country, COUNT(countries.code) AS cities_num
FROM countries
LEFT JOIN cities
ON countries.code = cities.country_code
GROUP BY country
-- Order by count of cities as cities_num
ORDER BY cities_num DESC, country;


/* Nesse caso, é necessário o 'Alias'*/
SELECT countries.country_name AS country,
-- Subquery that provides the count of cities 
  (SELECT
         COUNT(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country;

/* Subqueries no 'FROM'*/

-- Posso fazer o from com mais de uma tabela para aplicar filtro, por exemplo.
SELECT DISTINCT
      countries.local_name,
      languages.code
FROM countries, languages
-- Where codes match
WHERE countries.code = languages.code
ORDER BY languages.code DESC;


-- Select local_name and lang_num from appropriate tables
SELECT
      local_name,
      sub.lang_num
FROM countries, 
  (SELECT code, COUNT(*) AS lang_num
  FROM languages
  GROUP BY code) AS sub
-- Where codes match
WHERE countries.code = sub.code
ORDER BY lang_num DESC;

-- Select relevant fields
SELECT 
      code,
      inflation_rate,
      unemployment_rate
FROM economies
WHERE year = 2015 
  AND code NOT IN
-- Subquery returning country codes filtered on gov_form
	(SELECT
         code
   FROM countries
   WHERE gov_form LIKE '%Republic%' OR gov_form LIKE '%Monarchy%')
ORDER BY inflation_rate;

