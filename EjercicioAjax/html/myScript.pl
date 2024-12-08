#!/usr/bin/env perl

use strict;
use warnings;
use CGI;
use DBI;
use Encode;

# Configurar UTF-8 para la salida
binmode(STDOUT, ':encoding(UTF-8)');

# Configuración de la base de datos
my $dsn = "DBI:MariaDB:database=mascotas;host=mariadb";
my $username = "root";
my $password = "GerlU2024";

# Conexión a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError => 1, PrintError => 0 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Obtener datos del formulario
my $cgi = CGI->new;
my $nombre = $cgi->param('nombre') // '';
my $dueno = $cgi->param('dueno') // '';
my $especie = $cgi->param('especie') // '';
my $sexo = $cgi->param('sexo') // '';
my $fecha_nacimiento = $cgi->param('fecha_nacimiento') // '';
my $fecha_muerte = $cgi->param('fecha_muerte');
$fecha_muerte = undef if $fecha_muerte eq '';  # Asignar undef si el campo está vacío

# Insertar datos en la base de datos
eval {
    my $sth = $dbh->prepare("INSERT INTO mascotas (nombre, dueno, especie, sexo, fecha_nacimiento, fecha_muerte) VALUES (?, ?, ?, ?, ?, ?)");
    $sth->execute($nombre, $dueno, $especie, $sexo, $fecha_nacimiento, $fecha_muerte);
    $sth->finish();
};
if ($@) {
    print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
    print "<html><body><h2>Error al guardar los datos: $@</h2></body></html>";
    exit;
}

# Finalizar conexión
$dbh->disconnect();

# Responder al usuario
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
print "<html><body><h2>¡Datos guardados exitosamente!</h2></body></html>";
