CREATE TABLE Roles (
  id SERIAL PRIMARY KEY,
  nombre varchar(255) UNIQUE NOT NULL
);

CREATE TABLE Permisos (
  id SERIAL PRIMARY KEY,
  nombre varchar(255) UNIQUE NOT NULL,
  descripcion text
);

CREATE TABLE Permisos_Roles (
  id SERIAL PRIMARY KEY,
  rol_id int NOT NULL,
  permiso_id int NOT NULL
);

CREATE TABLE Tipos_Movimientos_Inventario (
  id SERIAL PRIMARY KEY,
  nombre varchar UNIQUE NOT NULL
);

CREATE TABLE Categorias (
  id SERIAL PRIMARY KEY,
  nombre varchar(100) UNIQUE NOT NULL
);

CREATE TABLE Proveedores (
  id SERIAL PRIMARY KEY,
  nombre varchar(255) UNIQUE NOT NULL,
  direccion varchar(255) NOT NULL,
  correo varchar(255) UNIQUE,
  telefono varchar(50)
);

CREATE TABLE Estados_Calendarios (
  id SERIAL PRIMARY KEY,
  nombre varchar(50) UNIQUE NOT NULL
);

CREATE TABLE Usuarios (
  id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  nombre varchar NOT NULL,
  apellidos varchar NOT NULL,
  rol_id int NOT NULL,
  email varchar UNIQUE NOT NULL,
  status varchar NOT NULL CHECK ("status" IN ('activo', 'inactivo')),
  local int,
  contrasena varchar NOT NULL,
  fechaNacimiento date NOT NULL,
  creacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  telefono varchar(50)
);

CREATE TABLE Locales (
  id SERIAL PRIMARY KEY,
  administrador_id int,
  nombre varchar(255) NOT NULL,
  direccion varchar(255),
  nit_emisor varchar(255)
);

CREATE TABLE Clientes (
  id SERIAL PRIMARY KEY,
  nombre varchar(255) NOT NULL,
  nit varchar(50) UNIQUE NOT NULL,
  direccion varchar(255),
  correo varchar(255) UNIQUE,
  telefono varchar(50)
);

CREATE TABLE Productos (
  codigo SERIAL PRIMARY KEY,
  nombre text UNIQUE NOT NULL,
  presentacion varchar(255) NOT NULL,
  proveedor_id int NOT NULL,
  precioVenta numeric(10,2) NOT NULL,
  precioCosto numeric(10,2) NOT NULL,
  receta boolean NOT NULL,
  stock_minimo int NOT NULL,
  detalles text
);

CREATE TABLE Promociones (
  id SERIAL PRIMARY KEY,
  descripcion text NOT NULL,
  descuento numeric(5,2) NOT NULL,
  fecha_inicio timestamp NOT NULL,
  fecha_final timestamp NOT NULL
);

CREATE TABLE Visitadores_Medicos (
  id SERIAL PRIMARY KEY,
  nombre varchar(255) NOT NULL,
  proveedor_id int,
  correo varchar(255) UNIQUE,
  telefono varchar(50),
  FOREIGN KEY (proveedor_id) REFERENCES Proveedores (id)
);

CREATE TABLE Lotes (
  id SERIAL PRIMARY KEY,
  producto_id int NOT NULL,
  lote varchar(255) NOT NULL,
  fecha_vencimiento date NOT NULL
);

CREATE TABLE Ventas (
  id SERIAL PRIMARY KEY,
  cliente_id int NOT NULL,
  total numeric(10,2) NOT NULL,
  tipo_pago varchar NOT NULL CHECK ("tipo_pago" IN ('efectivo', 'tarjeta', 'transacción'))
);

CREATE TABLE Compras (
  id SERIAL PRIMARY KEY,
  no_factura int UNIQUE NOT NULL,
  usuario_id int NOT NULL,
  proveedor_id int,
  total numeric NOT NULL,
  credito boolean NOT NULL,
  descripcion text
);

CREATE TABLE Pagos_Compras (
  id SERIAL PRIMARY KEY,
  compra_id int NOT NULL,
  cuotas int NOT NULL,
  estado varchar NOT NULL CHECK ("estado" IN ('pendiente', 'pagado')),
  total numeric(10,2) NOT NULL,
  fecha timestamp NOT NULL,
  detalles text
);

CREATE TABLE Inventario (
  id SERIAL PRIMARY KEY,
  lote_id int NOT NULL,
  cantidad int NOT NULL,
  tipo_movimiento_id int NOT NULL,
  venta_id int,
  compra_id int,
  precio_venta numeric(10,2) NOT NULL,
  precio_costo numeric(10,2) NOT NULL,
  local_id int NOT NULL,
  encargado_id int NOT NULL,
  fecha timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Facturas (
  id SERIAL PRIMARY KEY,
  venta_id int NOT NULL,
  local_id int NOT NULL,
  no_serie varchar(255) UNIQUE NOT NULL,
  numero_dte int NOT NULL,
  autorizacion varchar(255) NOT NULL,
  moneda varchar(100) NOT NULL,
  fecha_emision timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_certificacion timestamp
);

CREATE TABLE Recetas (
  id SERIAL PRIMARY KEY,
  producto_id int NOT NULL,
  venta_id int NOT NULL,
  archivo text NOT NULL
);

CREATE TABLE Documentos_Locales (
  id SERIAL PRIMARY KEY,
  nombre varchar(255) NOT NULL,
  usuario_id int NOT NULL,
  archivo text NOT NULL,
  local_id int NOT NULL,
  creacion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  vencimiento date
);

CREATE TABLE Promociones_Producto (
  id SERIAL PRIMARY KEY,
  producto_id int NOT NULL,
  promocion_id int NOT NULL
);

CREATE TABLE Categorias_Productos (
  id SERIAL PRIMARY KEY,
  categoria_id int NOT NULL,
  producto_id int NOT NULL
);

CREATE TABLE Catalogos_Visitadores (
  id SERIAL PRIMARY KEY,
  visitador_id int NOT NULL,
  archivo text NOT NULL
);

CREATE TABLE Calendario (
  id SERIAL PRIMARY KEY,
  usuario_id int NOT NULL,
  visitador_id int,
  titulo varchar(250) NOT NULL,
  estado_id int NOT NULL,
  detalles text,
  fecha timestamp NOT NULL
);

ALTER TABLE Lotes ADD FOREIGN KEY (producto_id) REFERENCES Productos (codigo);
ALTER TABLE productos ADD FOREIGN KEY (proveedor_id) REFERENCES proveedores (id);
ALTER TABLE facturas ADD FOREIGN KEY (venta_id) REFERENCES ventas (id);
ALTER TABLE facturas ADD FOREIGN KEY (local_id) REFERENCES locales (id);
ALTER TABLE compras ADD FOREIGN KEY (proveedor_id) REFERENCES proveedores (id);
ALTER TABLE pagos_compras ADD FOREIGN KEY (compra_id) REFERENCES compras (id);
ALTER TABLE locales ADD FOREIGN KEY (administrador_id) REFERENCES usuarios (id);
ALTER TABLE inventario ADD FOREIGN KEY (encargado_id) REFERENCES usuarios (id);
ALTER TABLE permisos_roles ADD FOREIGN KEY (permiso_id) REFERENCES permisos (id);
ALTER TABLE catalogos_visitadores ADD FOREIGN KEY (visitador_id) REFERENCES visitadores_medicos (id);
ALTER TABLE compras ADD FOREIGN KEY (usuario_id) REFERENCES usuarios (id);
ALTER TABLE recetas ADD FOREIGN KEY (producto_id) REFERENCES productos (codigo);
ALTER TABLE recetas ADD FOREIGN KEY (venta_id) REFERENCES ventas (id);
ALTER TABLE documentos_locales ADD FOREIGN KEY (usuario_id) REFERENCES usuarios (id);
ALTER TABLE documentos_locales ADD FOREIGN KEY (local_id) REFERENCES locales (id);
ALTER TABLE categorias_productos ADD FOREIGN KEY (categoria_id) REFERENCES categorias (id);
ALTER TABLE categorias_productos ADD FOREIGN KEY (producto_id) REFERENCES productos (codigo);
ALTER TABLE ventas ADD FOREIGN KEY (cliente_id) REFERENCES clientes (id);
ALTER TABLE promociones_producto ADD FOREIGN KEY (producto_id) REFERENCES productos (codigo);
ALTER TABLE promociones_producto ADD FOREIGN KEY (promocion_id) REFERENCES promociones (id);
ALTER TABLE calendario ADD FOREIGN KEY (usuario_id) REFERENCES usuarios (id);
ALTER TABLE calendario ADD FOREIGN KEY (visitador_id) REFERENCES visitadores_medicos (id);
ALTER TABLE inventario ADD FOREIGN KEY (local_id) REFERENCES locales (id);
ALTER TABLE inventario ADD FOREIGN KEY (tipo_movimiento_id) REFERENCES tipos_movimientos_inventario (id);
ALTER TABLE inventario ADD FOREIGN KEY (lote_id) REFERENCES lotes (id);
ALTER TABLE calendario ADD FOREIGN KEY (estado_id) REFERENCES estados_calendarios (id);
ALTER TABLE usuarios ADD FOREIGN KEY (rol_id) REFERENCES roles (id);
ALTER TABLE inventario ADD FOREIGN KEY (venta_id) REFERENCES ventas (id);
ALTER TABLE inventario ADD FOREIGN KEY (compra_id) REFERENCES compras (id);
ALTER TABLE clientes DROP COLUMN IF EXISTS telefono;
ALTER TABLE visitadores_medicos DROP COLUMN IF EXISTS telefono;
ALTER TABLE proveedores DROP COLUMN IF EXISTS telefono;
ALTER TABLE usuarios DROP COLUMN IF EXISTS telefono;

CREATE TABLE telefonos (
  id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  numero VARCHAR(20) NOT NULL,
  tipo VARCHAR NOT NULL CHECK (tipo IN ('móvil', 'fijo', 'otro')),
  usuario_id INT,
  proveedor_id INT,
  visitador_id INT,
  cliente_id INT
);

ALTER TABLE visitadores_medicos DROP CONSTRAINT IF EXISTS visitadores_medicos_proveedor_id_fkey;
ALTER TABLE visitadores_medicos ADD FOREIGN KEY (proveedor_id) REFERENCES proveedores (id);

ALTER TABLE telefonos ADD FOREIGN KEY (usuario_id) REFERENCES usuarios (id);
ALTER TABLE telefonos ADD FOREIGN KEY (proveedor_id) REFERENCES proveedores (id);
ALTER TABLE telefonos ADD FOREIGN KEY (visitador_id) REFERENCES visitadores_medicos (id);
ALTER TABLE telefonos ADD FOREIGN KEY (cliente_id) REFERENCES clientes (id);