#!/usr/bin/perl 
use strict;
use warnings;
use CGI qw(:standard);
use DBI;
use Text::Markdown 'markdown';

print "Content-type: text/html; charset=utf-8\n\n";

my $dsn = "DBI:mysql:database=nombre;host=localhost";
my $user = "root";
my $pass = "GerlU2024";
my $dbh  = DBI->connect($dsn, $user, $pass, { RaiseError => 1, PrintError => 0 })
    or die "No se pudo conectar a la base de datos: " . DBI->errstr;

my ($owner, $title) = (param('owner'), param('title'));

my $sth = $dbh->prepare("SELECT text FROM Articles WHERE owner=? AND title=?");
$sth->execute($owner, $title);

if (my $ref = $sth->fetchrow_hashref) {
    print markdown($ref->{text});
} else {
    print "Artículo no encontrado.";
}

$sth->finish;
$dbh->disconnect;
