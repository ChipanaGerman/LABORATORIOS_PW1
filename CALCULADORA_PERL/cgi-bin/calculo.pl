#!/usr/bin/perl
use strict;
use warnings;
use CGI;

# Crear un nuevo objeto CGI
my $cgi = CGI->new;

# Obtener la expresión del formulario
my $expresion = $cgi->param('expresion') || '';

# Función para calcular la expresión
sub calcular_expresion {
    my $expr = shift;

    # Eliminar espacios en blanco
    $expr =~ s/\s+//g;

    # Verificar que la expresión contenga solo números, operadores y paréntesis
    unless ($expr =~ /^[\d\+\-\*\/\(\)\.]+$/) {
        return 'Error: Expresión inválida';
    }

    # Resolver los paréntesis primero usando recursión
    while ($expr =~ /\(([^()]+)\)/) {
        my $sub_expr = $1;
        my $resultado_sub_expr = calcular_operacion($sub_expr);
        $expr =~ s/\Q($sub_expr)\E/$resultado_sub_expr/;
    }

    # Resolver la expresión final sin paréntesis
    return calcular_operacion($expr);
}
