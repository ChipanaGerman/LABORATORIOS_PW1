#!/usr/bin/perl
use strict;
use warnings;

# Pide el nombre de usuario
print "Ingrese el nombre de usuario: ";
my $usuario = <STDIN>;
chomp($usuario);  # Elimina el salto de línea

# Pide el dominio
print "Ingrese el dominio: ";
my $dominio = <STDIN>;
chomp($dominio);  # Elimina el salto de línea

# Imprime el correo utilizando interpolación
print "$usuario\@$dominio\n";



