USE northwind;

/*1. Selecciona todos los campos de los productos, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, que tengan stock en el almacén 
y al mismo tiempo que sus precios unitarios estén entre 50 y 100. Por último, ordena los resultados por código de proveedor de forma ascendente.*/


SELECT * #seleccionamos todos los campos de tabla products
	FROM products
	WHERE supplier_id IN (1, 3, 7, 8, 9) AND units_in_stock > 0 AND unit_price BETWEEN 50 AND 100 #imponemos estas condiciones
	ORDER BY supplier_id; #ordenamos los resultados por el proveedor que cumpla las condiciones del WHERE

    
/*2. Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6,
además que hayan vendido a clientes que tengan códigos que comiencen con las letras de la A hasta la G. 
Por último, en esta búsqueda queremos filtrar solo por aquellos envíos que la fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de 
cualquier año*/

SELECT employee_id, first_name, last_name, order_date, customer_id #lo que queremos mostrar
FROM employees #de la tabla empleadas
NATURAL JOIN orders #uniéndolo 
WHERE employee_id BETWEEN 3 AND 6 #que el empleado esté entre la posición 3 y la 6 (incluídas)
	AND (DAY(order_date) BETWEEN 22 AND '31') AND MONTH(order_date) = 12 #de la columna order_date, que sean 
    AND customer_id REGEXP '^[A-G].*';


/*3. Calcula el precio de venta de cada pedido una vez aplicado el descuento. Muestra el id del la orden, 
el id del producto, el nombre del producto, el precio unitario, la cantidad, el descuento y el precio de venta después de haber aplicado el descuento.*/

SELECT o1.order_id, o1.product_id, o2.product_name, o1.unit_price, o1.quantity, o1.discount, (o1.unit_price *o1.quantity) * (1- o1.discount) AS PrecioVenta
FROM order_details AS o1 #desde la tabla order_details queremos que también consulte con inner
INNER JOIN products AS o2 #unimos order_details a products por inner porque usamos columnas que no  se llaman igual
ON o1.product_id = o2.product_id; #nos dice por las columna que lo unimos


/*4. Usando una subconsulta, muestra los productos cuyos precios estén por encima del precio medio total de los productos de la BBDD.*/

SELECT product_name, unit_price                 #esta consulta engloba la subconsulta, y nos dice que saque por pantalla las columnas del select
	FROM products
	WHERE unit_price > (                         # donde el precio unitario sea mayor que lo que engloba la subconsulta
						SELECT AVG(unit_price)   #esta consula nos enseña la media del precio unitario
						FROM products);          #de productos


/*5. ¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?*/

SELECT first_name, last_name, product_name AS "Producto", SUM(quantity) AS "TotalVendido", employees.employee_id #le pedimos que nos sume la cantidad de los productos 
	FROM employees
	INNER JOIN orders #lo unimos por inner porque necesitamos unirlas pero por diferentes columnas
		ON employees.employee_id = orders.employee_id  
	INNER JOIN order_details
		ON order_details.order_id = orders.order_id
	INNER JOIN products
		ON order_details.product_id = products.product_id
	GROUP BY employees.employee_id, products.product_name #agrupamos con group by porque tenemos la función de agregación SUM
	ORDER BY employees.employee_id, Producto;
