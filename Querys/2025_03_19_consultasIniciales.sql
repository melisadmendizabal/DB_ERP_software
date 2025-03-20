--CONSULTAS 
--Listar usuarios 
SELECT u.id, u.nombre, u.apellidos, r.nombre AS rol, u.email, u.status 
FROM Usuarios u
JOIN Roles r ON u.rol_id = r.id;

-- Obtener todos los documentos de cada local
SELECT d.id, d.nombre, u.nombre AS usuario, l.nombre AS local, d.vencimiento
FROM Documentos_Locales d
JOIN Usuarios u ON d.usuario_id = u.id
JOIN Locales l ON d.local_id = l.id;

--Facturas con local
SELECT f.id, f.no_serie, f.numero_dte, f.moneda, l.nombre AS local, u.nombre AS administrador
FROM Facturas f
JOIN Locales l ON f.local_id = l.id
JOIN Usuarios u ON l.administrador_id = u.id;

--Cantidad de empleados por rol
SELECT r.nombre AS rol, COUNT(u.id) AS total_usuarios
FROM Roles r
LEFT JOIN Usuarios u ON r.id = u.rol_id
GROUP BY r.nombre;

--Facturas y pagos
SELECT p.id, c.no_factura, p.estado, p.total, p.fecha, p.detalles
FROM Pagos_Compras p
JOIN Compras c ON p.compra_id = c.id;

--Productos en los locales
SELECT l.nombre AS local, p.nombre AS producto, SUM(i.cantidad) AS stock_total
FROM Inventario i
JOIN Lotes lo ON i.lote_id = lo.id
JOIN Productos p ON lo.producto_id = i.id
JOIN Locales l ON i.local_id = l.id
GROUP BY l.nombre, p.nombre;
