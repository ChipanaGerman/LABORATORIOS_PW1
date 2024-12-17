-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS nombre;

-- Usar la base de datos
USE nombre;

-- Crear la tabla Users si no existe
CREATE TABLE IF NOT EXISTS Users (
    userName VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    firstName VARCHAR(50),
    lastName VARCHAR(50)
);

-- Crear la tabla Articles si no existe
CREATE TABLE IF NOT EXISTS Articles (
    title VARCHAR(100),
    owner VARCHAR(50),
    text TEXT,
    PRIMARY KEY (title, owner),
    FOREIGN KEY (owner) REFERENCES Users(userName) ON DELETE CASCADE
);
