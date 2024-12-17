#!/usr/bin/perl 
use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser'; 
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
my $firstname = param('firstName');
my $lastname = param('lastName');

my $xml = XML::Simple->new();
my $output;

if (!$username || !$password || !$firstname || !$lastname) {
    $output = { owner => "", firstName => "", lastName => "" };
} else {
    my $sth_check = $dbh->prepare("SELECT COUNT(*) FROM Users WHERE userName = ?");
    $sth_check->execute($username);
    my ($count) = $sth_check->fetchrow_array();
    $sth_check->finish;

    if ($count > 0) {
        $output = { owner => "", firstName => "", lastName => "" };
    } else {
        my $sth_insert = $dbh->prepare("INSERT INTO Users (userName, password, firstName, lastName) VALUES (?, ?, ?, ?)");
        $sth_insert->execute($username, $password, $firstname, $lastname);
        $sth_insert->finish;
        $output = { owner => $username, firstName => $firstname, lastName => $lastname };
    }
}

print $xml->XMLout($output, RootName => 'user');

$dbh->disconnect;