#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(min max sum);

sub calcular_promedio {
    my @notas = @_;

    # Encuentra la nota mínima y máxima
    my $nota_min = min @notas;
    my $nota_max = max @notas;

    # Filtra las notas para eliminar la mínima y duplicar la máxima
    @notas = grep { $_ != $nota_min } @notas;  # Elimina la mínima
    push @notas, $nota_max;  # Duplica la máxima

    # Calcula el promedio
    my $promedio = sum(@notas) / @notas;

    return $promedio;
}

# Solicitar las notas al usuario
print "Ingrese las notas separadas por espacio: ";
my $input = <STDIN>;  # Leer la entrada del usuario
chomp($input);  # Eliminar el salto de línea al final

# Convertir la entrada en un arreglo de números
my @notas = split(' ', $input);

# Verificar que el usuario haya ingresado al menos dos notas
if (scalar @notas < 2) {
    print "Debe ingresar al menos dos notas.\n";
    exit;
}

# Calcular el promedio
my $promedio = calcular_promedio(@notas);
print "El promedio es: $promedio\n";
