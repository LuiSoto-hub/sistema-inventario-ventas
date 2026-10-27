-- Proyecto: sistema-inventario-ventas
-- Autor: José Luis Soto Chávez

DROP DATABASE IF EXISTS sistema_inventario_ventas;
CREATE DATABASE sistema_inventario_ventas;
USE sistema_inventario_ventas;

-- Tablas
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    existencia INT NOT NULL DEFAULT 0,
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE detalle_venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES ventas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Trigger: resta inventario al vender
CREATE TRIGGER restar_inventario
AFTER INSERT ON detalle_venta
FOR EACH ROW
UPDATE productos
SET existencia = existencia - NEW.cantidad
WHERE id = NEW.producto_id;

-- Datos de prueba
INSERT INTO categorias (nombre) VALUES
('Bebidas'), ('Botanas'), ('Lácteos');

INSERT INTO productos (nombre, precio, existencia, categoria_id) VALUES
('Coca-Cola 600 ml', 18.50, 24, 1),
('Agua natural 1 L', 12.00, 30, 1),
('Papas Sabritas', 20.00, 15, 2),
('Leche Lala 1 L', 28.00, 10, 3);

INSERT INTO clientes (nombre, telefono, email) VALUES
('Juan Pérez', '5512345678', 'juan@correo.com');