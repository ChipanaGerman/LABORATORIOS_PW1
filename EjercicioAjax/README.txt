ACCEDER A BASE DATOS:
docker exec -it mariadb-container bash
mysql -u root -p
GerlU2024
USE mascotas;
SELECT * FROM mascotas;

COMANDOS DOCKER: 
docker-compose build
docker-compose up