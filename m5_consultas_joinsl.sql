-- CREAR BASE DE DATOS
CREATE DATABASE Ventas_Tech_DB;
GO

-- SELECCIONAR LA BASE DE DATOS
USE Ventas_Tech_DB;
GO

 ==========================================
 SECCIÓN 1: DROP TABLES
 ==========================================

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

 ==========================================
 SECCIÓN 2: CREATE TABLES
==========================================

-- TABLA 1: CATEGORIAS

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);

-- TABLA 3: PRODUCTOS

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo BIT DEFAULT 1,

    FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
);
-- TABLA 4: VENTAS

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,

    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

 ==========================================)
 SECCIÓN 3: INSERT DATA
 ==========================================

-- INSERTAR CATEGORIAS (4 REGISTROS)

INSERT INTO categorias
(id_categoria, nombre_categoria, descripcion)
VALUES
(1, 'Computación',    'Laptops, PCs y monitores'),
(2, 'Accesorios',     'Periféricos y complementos'),
(3, 'Audio',          'Auriculares y parlantes'),
(4, 'Almacenamiento', 'Discos y memorias');

-- INSERTAR CLIENTES (5 REGISTROS)

INSERT INTO clientes
(id_cliente, nombre, email, ciudad, fecha_registro)
VALUES
(1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05'),
(2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10'),
(3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01'),
(4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15'),
(5, 'Laura Torres', 'laura@mail.com', 'Tucumán',      '2024-03-01');

-- INSERTAR PRODUCTOS (6 REGISTROS)

INSERT INTO productos
(id_producto, nombre_producto, id_categoria, precio, stock, activo)
VALUES
(1, 'Laptop Pro 15',      1, 1200.00, 15, 1),
(2, 'Mouse Inalámbrico',  2,   28.00, 80, 1),
(3, 'Monitor 4K 27',      1,  450.00, 12, 1),
(4, 'Auriculares BT Pro', 3,  120.00, 35, 1),
(5, 'SSD Externo 1TB',    4,  130.00, 18, 1),
(6, 'Teclado Mecánico',   2,   95.00, 40, 1);



SELECT
    p.id_producto,
    p.nombre_producto,
    c.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias c
    ON p.id_categoria = c.id_categoria;

    -- INSERTAR VENTAS (10 REGISTROS)

INSERT INTO ventas
(id_venta, id_cliente, id_producto, cantidad,
 precio_unitario, fecha_venta)
VALUES
( 1, 1, 1, 2, 1200.00, '2024-03-05'),
( 2, 2, 2, 5,   28.00, '2024-03-06'),
( 3, 3, 3, 1,  450.00, '2024-03-07'),
( 4, 1, 4, 2,  120.00, '2024-03-08'),
( 5, 4, 5, 3,  130.00, '2024-03-10'),
( 6, 2, 6, 4,   95.00, '2024-03-11'),
( 7, 5, 1, 1, 1200.00, '2024-03-12'),

SELECT 'categorias' AS tabla, COUNT(*) AS total
FROM categorias

UNION ALL

SELECT 'clientes', COUNT(*)
FROM clientes

UNION ALL

SELECT 'productos', COUNT(*)
FROM productos

UNION ALL

SELECT 'ventas', COUNT(*)
FROM ventas;



------------------------------------------------------------------------
------------------------m5_consultas_joins------------------------------

-- PROYECTO: TECHSTORE - VENTAS_TECH_DB
-- MODULO 5: CONSULTAS CON JOIN Y UNION ALL
-- MOTOR: SQL Server (SSMS)

USE Ventas_Tech_DB;
GO

-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- SE CRUZA VENTAS, CLIENTES, PRODUCTOS Y CATEGORIAS.

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS ciudad_cliente,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    CAST(v.cantidad * v.precio_unitario AS DECIMAL(12,2)) AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;
GO

-- HALLAZGO: LA VISTA REUNE LAS 10 VENTAS REGISTRADAS CON DATOS 
 --- DE CLIENTES, PRODUCTOS, CATEGORIAS Y CIUDAD PARA SEGMENTAR POWER BI.

-- CONSULTA 2: CLIENTES REGISTRADOS SIN VENTAS  (LEFT JOIN)


SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
GO

-- HALLAZGO: APARECEN 0 CLEINTES SIN COMPRAS. LOS 5 CLIENTES REGISTRADOS TIENEN AL MENOS UNA VENTA. 


-- CONSULTA 3: PRODUCTOS DEL CATALOGO SIN VENTAS (LEFT JOIN)
SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
GO

-- HALLAZGO:  APARECEN  0 PRODUCTOS SIN VENTAS. LOS 6 ARTICULOS DEL CATALOGO REGISTRAN AL MENOS UNA OPERACIÓN



-- CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL)
-- SE CREAN DOS ORIGENES FICTICIOS SEGÚN EL PERIODO DE MARZO, LA COLUMNA CANAL NO PROVIENE DE UNA TABLE 

WITH ventas_por_canal AS (
    SELECT
        'Primera quincena de marzo' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM ventas
    WHERE fecha_venta >= '2024-03-01'
      AND fecha_venta < '2024-03-11'

    UNION ALL

    SELECT
        'Segunda quincena de marzo' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM ventas
    WHERE fecha_venta >= '2024-03-11'
      AND fecha_venta < '2024-04-01'
)
SELECT
    canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total_venta) AS total_facturado
FROM ventas_por_canal
GROUP BY canal
ORDER BY total_facturado DESC;
GO

-- HALLAZGO: LA PRIMERA QUINCENA FACTURA $3.620 EN 5 VENTAS Y LA 2DA.$2.824 EN 5 VENTAS
--  LA PRIMERA SUPERA A LA SEGUNDA POR $796
