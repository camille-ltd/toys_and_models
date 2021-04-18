#QUESTION 1 : Le nombre de products vendus par catégorie et par mois, 
#avec comparaison et taux d'évolution par rapport au même mois de l'année précédente.


WITH turnover_product AS(
	SELECT p.productLine as product,YEAR(o.orderDate) as annee, MONTH(o.orderDate) as mois, SUM(od.quantityOrdered) as total_quantity
	FROM orderdetails as od
	JOIN products as p
	ON od.productCode = p.productCode
	JOIN orders as o
	ON od.orderNumber = o.orderNumber
	GROUP BY product, annee, mois),
	turnover_product2 AS (
	SELECT product, total_quantity, annee, mois,
	SUM(CASE WHEN mois = 1 THEN total_quantity ELSE NULL END) janvier,
	SUM(CASE WHEN mois = 2 THEN total_quantity ELSE NULL END) fevrier,
	SUM(CASE WHEN mois = 3 THEN total_quantity ELSE NULL END) mars,
	SUM(CASE WHEN mois = 4 THEN total_quantity ELSE NULL END) avril,
	SUM(CASE WHEN mois = 5 THEN total_quantity ELSE NULL END) mai,
	SUM(CASE WHEN mois = 6 THEN total_quantity ELSE NULL END) juin,
	SUM(CASE WHEN mois = 7 THEN total_quantity ELSE NULL END) juillet,
	SUM(CASE WHEN mois = 8 THEN total_quantity ELSE NULL END) août,
	SUM(CASE WHEN mois = 9 THEN total_quantity ELSE NULL END) septembre,
	SUM(CASE WHEN mois = 10 THEN total_quantity ELSE NULL END) octobre,
	SUM(CASE WHEN mois = 11 THEN total_quantity ELSE NULL END) novembre,
	SUM(CASE WHEN mois = 12 THEN total_quantity ELSE NULL END) decembre
	FROM turnover_product
	GROUP BY product,annee, mois
	ORDER BY product,annee, mois)
SELECT product, total_quantity, annee, mois, janvier, 
100 * (janvier- lag(janvier, 12) over (partition by product)) / lag(janvier, 12) over (partition by product) as '(%) janvier',
fevrier, 
100 * (fevrier- lag(fevrier, 12) over (partition by product)) / lag(fevrier, 12) over (partition by product) as '(%) fevrier',
mars,
100 * (mars- lag(mars, 12) over (partition by product)) / lag(mars, 12) over (partition by product) as '(%) mars',
avril,
100 * (avril- lag(avril, 12) over (partition by product)) / lag(avril, 12) over (partition by product) as '(%) avril',
mai,
100 * (mai- lag(mai, 12) over (partition by product)) / lag(mai, 12) over (partition by product) as '(%) mai',
juin,
100 * (juin- lag(juin, 12) over (partition by product)) / lag(juin, 12) over (partition by product) as '(%) juin',
juillet,
100 * (juillet- lag(juillet, 12) over (partition by product)) / lag(juillet, 12) over (partition by product) as '(%) juillet',
août,
100 * (août- lag(août, 12) over (partition by product)) / lag(août, 12) over (partition by product) as '(%) aout',
septembre,
100 * (septembre- lag(septembre, 12) over (partition by product)) / lag(septembre, 12) over (partition by product) as '(%) septembre',
octobre,
100 * (octobre- lag(octobre, 12) over (partition by product)) / lag(octobre, 12) over (partition by product) as '(%) octobre',
novembre,
100 * (novembre- lag(novembre, 12) over (partition by product)) / lag(novembre, 12) over (partition by product) as '(%) septembre',
decembre,
100 * (decembre- lag(decembre, 12) over (partition by product)) / lag(decembre, 12) over (partition by product) as '(%) decembre'
FROM turnover_product2
GROUP BY 1, product, total_quantity, annee, mois, janvier, fevrier, mars, avril, mai, juin, juillet, août, septembre, octobre, novembre, decembre;




select 
from orders o
group by 1;





SELECT count(*)
FROM orderdetails o 
GROUP BY quantityOrdered ;



#QUESTION 2 : Le chiffre d'affaires des commandes des deux derniers mois par pays. date du jour -2 mois


WITH turnover_by_country AS(
	SELECT country, orderDate,SUM(quantityOrdered*priceEach) as CA,
	ADDDATE(NOW(), INTERVAL -1 MONTH) as required_date2,  ADDDATE(NOW(), INTERVAL -2 MONTH) as required_date1 
	FROM orders o 
	JOIN customers c 
	ON o.customerNumber = c.customerNumber
	JOIN orderdetails o2
	ON o.orderNumber = o2.orderNumber
	GROUP BY c.country, o.orderDate ORDER BY o.orderDate DESC)
SELECT country, orderDate, CA, MONTH(required_date1), MONTH(required_date2)
FROM turnover_by_country;

SELECT country, MAX(orderDate), (MAX(orderDate) - 1), SUM(quantityOrdered*priceEach) as CA
FROM orders o 
JOIN customers c 
ON o.customerNumber = c.customerNumber
JOIN orderdetails o2
ON o.orderNumber = o2.orderNumber
GROUP BY orderDate, country
ORDER BY orderDate DESC;





SELECT country, orderDate, MONTH(orderDate),SUM(quantityOrdered*priceEach) as CA
FROM orders o 
JOIN customers c 
ON o.customerNumber = c.customerNumber
JOIN orderdetails o2
ON o.orderNumber = o2.orderNumber
GROUP BY country, YEAR(orderDate), MONTH(orderDate) 
ORDER BY country, YEAR(orderDate) DESC;


-- SELECT MONTH(required_date1), MONTH(required_date2) FROM 
-- (SELECT c.country, o.orderDate,SUM(o2.quantityOrdered*o2.priceEach) as CA, 
-- ADDDATE(NOW(), INTERVAL -1 MONTH) as required_date2,  ADDDATE(NOW(), INTERVAL -2 MONTH) as required_date1) as last_month 	
-- FROM orders o 
-- JOIN customers c 
-- ON o.customerNumber = c.customerNumber
-- JOIN orderdetails o2
-- ON o.orderNumber = o2.orderNumber
-- GROUP BY c.country, o.orderDate ORDER BY o.orderDate DESC) as turnover_by_country;




-- WITH product_ca AS(c.country, o.orderDate,SUM(o2.quantityOrdered*o2.priceEach)
-- FROM orders o 
-- JOIN customers c 
-- ON o.customerNumber = c.customerNumber
-- JOIN orderdetails o2
-- ON o.orderNumber = o2.orderNumber
-- GROUP BY c.country, o.orderDate ORDER BY o.orderDate DESC);

#QUESTION 3 : Le stock des 5 products les plus commandés.

SELECT productName, quantityInStock, SUM(o2.quantityOrdered) as total
FROM products p
JOIN orderdetails o2 
ON p.productCode = o2.productCode
GROUP BY p.productName, p.quantityInStock
ORDER BY total DESC LIMIT 5;

#QUESTION 4

SELECT e.firstName, e.lastName,YEAR(o.shippedDate) as annee, MONTH(o.shippedDate)as mois, 
SUM(o2.quantityOrdered * o2.priceEach) as CA
FROM employees e
JOIN customers c 
ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o 
ON c.customerNumber = o.customerNumber
JOIN orderdetails o2 
ON o.orderNumber = o2.orderNumber
GROUP BY e.firstName, e.lastName, annee, mois;


SELECT YEAR(o.shippedDate) as annee, MONTH(o.shippedDate)as mois, SUM(o2.quantityOrdered), SUM(o2.priceEach)
FROM orders o 
JOIN orderdetails o2 
ON o.orderNumber = o2.orderNumber
GROUP BY annee, mois;




######
SELECT YEAR(orderDate) as annee, SUM(quantityOrdered * priceEach) as turnover
FROM orderdetails o 
JOIN orders o2 
ON o.orderNumber = o2.orderNumber
GROUP BY year;




















