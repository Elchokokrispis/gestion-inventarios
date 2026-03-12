-- ============================================
-- SISTEMA DE GESTIÓN DE INVENTARIOS
-- Base de Datos: gestion_inventarios
-- Archivo: 01_schema.sql
-- ============================================

-- Eliminar base si existe (para limpieza)
DROP DATABASE IF EXISTS gestion_inventarios;

-- Crear base de datos
CREATE DATABASE gestion_inventarios 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE gestion_inventarios;

-- ============================================
-- 1. TABLA DE USUARIOS
-- ============================================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'operario', 'gerente') DEFAULT 'operario',
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2. TABLA DE CATEGORÍAS
-- ============================================
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 3. TABLA DE PROVEEDORES
-- ============================================
CREATE TABLE proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 4. TABLA DE PRODUCTOS (Principal)
-- ============================================
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_sku VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    categoria_id INT,
    proveedor_id INT,
    stock_actual INT DEFAULT 0,
    stock_minimo INT DEFAULT 10,
    precio_costo DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    ubicacion_almacen VARCHAR(50),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

-- ============================================
-- 5. TABLA DE MOVIMIENTOS DE STOCK
-- ============================================
CREATE TABLE movimientos_stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    tipo ENUM('entrada', 'salida', 'ajuste') NOT NULL,
    cantidad INT NOT NULL,
    stock_anterior INT NOT NULL,
    stock_nuevo INT NOT NULL,
    motivo TEXT,
    usuario_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- ============================================
-- 6. TABLA DE ALERTAS DE STOCK
-- ============================================
CREATE TABLE alertas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    tipo_alerta ENUM('stock_bajo', 'sin_stock', 'vencimiento') NOT NULL,
    mensaje TEXT,
    fecha_generada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_resuelta TIMESTAMP NULL,
    resuelta BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- ============================================
-- MENSAJE DE CONFIRMACIÓN
-- ============================================
SELECT 'Base de datos gestion_inventarios creada exitosamente' AS mensaje;