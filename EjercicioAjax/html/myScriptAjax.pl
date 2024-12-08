#!/usr/bin/env perl

use strict;
use warnings;
use CGI;
use DBI;
use JSON;
use Encode;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

# Configurar UTF-8 para la salida
binmode(STDOUT, ':encoding(UTF-8)');

# Configuración de la base de datos
my $dsn = "DBI:MariaDB:database=mascotas;host=mariadb";
my $username = "root";
my $password = "GerlU2024";

# Conexión a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError => 1, PrintError => 0 })
    or die to_json({ error => "No se pudo conectar a la base de datos: $DBI::errstr" });

# Obtener datos del formulario
my $cgi = CGI->new;
my $nombre = $cgi->param('nombre') // '';
my $dueno = $cgi->param('dueno') // '';
my $especie = $cgi->param('especie') // '';
my $sexo = $cgi->param('sexo') // '';
my $fecha_nacimiento = $cgi->param('fecha_nacimiento') // '';
my $fecha_muerte = $cgi->param('fecha_muerte');
$fecha_muerte = undef if defined($fecha_muerte) && $fecha_muerte eq '';  # Asignar undef si está vacío

my %response;

if ($nombre && $dueno && $especie && $sexo && $fecha_nacimiento) {
    eval {
        # Preparar e insertar datos
        my $sth = $dbh->prepare("INSERT INTO mascotas (nombre, dueno, especie, sexo, fecha_nacimiento, fecha_muerte) VALUES (?, ?, ?, ?, ?, ?)");
        $sth->execute($nombre, $dueno, $especie, $sexo, $fecha_nacimiento, $fecha_muerte);

        # Obtener el ID recién insertado
        my $last_id = $dbh->last_insert_id(undef, undef, 'mascotas', 'id');

        # Crear el mensaje con los datos guardados
        my $mensaje = "¡Datos guardados exitosamente!\n";
        $mensaje .= "ID: $last_id\n";
        $mensaje .= "Nombre: $nombre\n";
        $mensaje .= "Dueno: $dueno\n";
        $mensaje .= "Especie: $especie\n";
        $mensaje .= "Sexo: $sexo\n";
        $mensaje .= "Fecha de nacimiento: $fecha_nacimiento\n";
        $mensaje .= "Fecha de muerte: " . ($fecha_muerte // 'No aplica') . "\n";

        # Crear respuesta de éxito
        %response = (
            status => 'success',
            message => $mensaje,
            data => {
                id => $last_id,
                nombre => $nombre,
                dueno => $dueno,
                especie => $especie,
                sexo => $sexo,
                fecha_nacimiento => $fecha_nacimiento,
                fecha_muerte => $fecha_muerte // 'No aplica',
            }
        );
    };
    if ($@) {
        %response = (
            status => 'error',
            message => "Error al guardar los datos: $@"
        );
    }
} else {
    %response = (
        status => 'error',
        message => "Faltan datos obligatorios."
    );
}

# Cerrar conexión
$dbh->disconnect();

# Responder en formato JSON
print $cgi->header('application/json; charset=UTF-8');
print encode_json(\%response);

