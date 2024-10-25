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

# Función para evaluar la operación sin paréntesis
sub calcular_operacion {
    my $expr = shift;

    # Primero, resolver multiplicación y división de izquierda a derecha
    while ($expr =~ /(-?\d+(?:\.\d+)?)([\*\/])(-?\d+(?:\.\d+)?)/) {
        my ($num1, $op, $num2) = ($1, $2, $3);
        
        # Manejar el caso de división por cero
        if ($op eq '/' && $num2 == 0) {
            return $num1 == 0 ? 'Indefinido' : 'Infinito';
        }

        my $resultado = ($op eq '*') ? $num1 * $num2 : $num1 / $num2;
        $expr =~ s/\Q$num1$op$num2\E/$resultado/;
    }

    # Resolver suma y resta de izquierda a derecha
    while ($expr =~ /(-?\d+(?:\.\d+)?)([\+\-])(-?\d+(?:\.\d+)?)/) {
        my ($num1, $op, $num2) = ($1, $2, $3);
        my $resultado = ($op eq '+') ? $num1 + $num2 : $num1 - $num2;
        $expr =~ s/\Q$num1$op$num2\E/$resultado/;
    }

    return $expr;
}

# Calcular el resultado
my $resultado = calcular_expresion($expresion);

# Imprimir el encabezado HTTP y el HTML
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
print <<"HTML";
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculadora Web</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <div class="calculator">
        <h1>Calculadora</h1>
        <form action="/cgi-bin/calculo.pl" method="GET">
            <input type="text" name="expresion" id="expresion" value="$expresion" placeholder="Ingresa la expresión:" required>
            <br>
            <button type="submit">Calcular</button>
        </form>
        <div class="resultado">
            Resultado: <input type="text" id="resultado" readonly value="$resultado">
        </div>
    </div>
	<footer class="footer">		
	  	Chipana Jerónimo, German Arturo &copy; 2024/10/24 - Programación Web Lab. Grupo D.	  		
	</footer>
</body>
</html>
HTML