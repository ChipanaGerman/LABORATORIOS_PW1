#!/usr/bin/perl 
use strict;
use warnings;
use CGI qw(:standard);
use DBI;
use XML::Simple;

print "Content-type: text/xml; charset=utf-8\n\n";
print '<?xml version="1.0" encoding="UTF-8"?>' . "\n";

my $dsn = "DBI:mysql:database=nombre;host=localhost";
my $user = "root";
my $pass = "GerlU2024";
my $dbh  = DBI->connect($dsn, $user, $pass, { RaiseError => 1, PrintError => 0 })
    or die "No se pudo conectar a la base de datos: " . DBI->errstr;

my $username = param('userName');
my $password = param('password');

my $sth = $dbh->prepare("SELECT userName, firstName, lastName FROM Users WHERE userName=? AND password=?");
$sth->execute($username, $password);

my $xml = XML::Simple->new();
my $output;

if (my $ref = $sth->fetchrow_hashref) {
    $output = { user => { owner => $ref->{userName}, firstName => $ref->{firstName}, lastName => $ref->{lastName} } };
} else {
    $output = { user => { owner => "", firstName => "", lastName => "" } };
}

print $xml->XMLout($output, RootName => undef);
$sth->finish;
$dbh->disconnect;
