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

# Configuración de conexión a la base de datos
my $dsn = "DBI:MariaDB:database=mascotas;host=mariadb";
my $user = "root";
my $password = "GerlU2024";

# Instanciar CGI
my $cgi = CGI->new;

# Configuración de encabezados
print $cgi->header('application/json');

# Leer parámetros enviados
my $id = $cgi->param('id');

# Validar que el ID exista
if (!$id) {
    print encode_json({ success => 0, message => "El ID de la mascota es obligatorio." });
    exit;
}

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0 });

eval {
    # Eliminar mascota
    my $sql = "DELETE FROM mascotas WHERE id = ?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($id);

    if ($sth->rows > 0) {
        print encode_json({ success => 1, message => "Mascota eliminada correctamente." });
    } else {
        print encode_json({ success => 0, message => "No se encontro la mascota con ID $id." });
    }
    $sth->finish;
};

if ($@) {
    print encode_json({ success => 0, message => "Error al eliminar: $@" });
}

$dbh->disconnect;
