-- Crear la base de datos "app1"
CREATE DATABASE IF NOT EXISTS app1;
USE app1;

-- Crear la tabla "m7"
CREATE TABLE IF NOT EXISTS m7 (
  nombre TEXT,
  apodo TEXT,
  INDEX idx_nombre (nombre),
  INDEX idx_apodo (apodo)
);
