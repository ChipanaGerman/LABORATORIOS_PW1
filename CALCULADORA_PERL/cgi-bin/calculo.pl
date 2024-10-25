#!/usr/bin/perl
use strict;
use warnings;
use CGI;

# Crear un nuevo objeto CGI
my $cgi = CGI->new;

# Obtener la expresión del formulario
my $expresion = $cgi->param('expresion') || '';


