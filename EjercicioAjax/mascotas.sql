-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS mascotas;

-- Usar la base de datos
USE mascotas;

-- Crear la tabla "mascotas"
CREATE TABLE IF NOT EXISTS mascotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    dueno VARCHAR(50) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    sexo ENUM('m', 'f') NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    fecha_muerte DATE DEFAULT NULL
);

-- Insertar registros iniciales
INSERT INTO mascotas (nombre, dueno, especie, sexo, fecha_nacimiento, fecha_muerte) VALUES
('Fluffy', 'Harold', 'gato', 'f', '1993-02-04', NULL),
('Claws', 'Gwen', 'gato', 'm', '1994-03-17', NULL),
('Buffy', 'Harold', 'perro', 'f', '1989-05-13', NULL),
('Fang', 'Benny', 'perro', 'm', '1998-08-27', NULL),
('Puffball', 'Diane', 'hamster', 'f', '1999-03-30', NULL),
('Bowser', 'Diane', 'perro', 'm', '1979-08-31', '1995-07-29'),
('Chirpy', 'Gwen', 'pajaro', 'f', '1998-09-11', NULL),
('Whistler', 'Gwen', 'pajaro', 'm', '1997-12-09', NULL),
('Slim', 'Benny', 'serpiente', 'm', '1996-04-29', NULL),
('Rocky', 'Alex', 'hamster', 'm', '2020-05-20', NULL),
('Lucas', 'German Chipana', 'perro', 'm', '2021-06-30', NULL);
