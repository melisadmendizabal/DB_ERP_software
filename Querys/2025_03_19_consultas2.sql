--Cantidad de productos por proveedor
SELECT p.nombre AS proveedor, COUNT(pr.codigo) AS cantidad_productos
FROM Proveedores p
LEFT JOIN Productos pr ON p.id = pr.proveedor_id
GROUP BY p.nombre
ORDER BY cantidad_productos DESC;

--Ventas con el nombre del cliente, total y tipo de pago
SELECT v.id AS venta_id, c.nombre AS cliente, v.total, v.tipo_pago
FROM Ventas v
JOIN Clientes c ON v.cliente_id = c.id
ORDER BY v.id DESC;

--Inventario disponible de cada producto en cada local:
SELECT l.nombre AS local, p.nombre AS producto, SUM(i.cantidad) AS stock
FROM Inventario i
JOIN Lotes lt ON i.lote_id = lt.id
JOIN Productos p ON lt.producto_id = p.codigo
JOIN Locales l ON i.local_id = l.id
GROUP BY l.nombre, p.nombre
ORDER BY l.nombre, stock DESC;