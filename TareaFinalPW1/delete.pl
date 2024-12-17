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

my ($owner, $title) = (param('owner'), param('title'));

my $sth_check = $dbh->prepare("SELECT COUNT(*) FROM Articles WHERE owner=? AND title=?");
$sth_check->execute($owner, $title);
my ($count) = $sth_check->fetchrow_array();
$sth_check->finish;

my $output;

if ($count > 0) {
    my $sth = $dbh->prepare("DELETE FROM Articles WHERE owner=? AND title=?");
    if ($sth->execute($owner, $title)) {
        $output = { article => { owner => $owner, title => $title } };
    } else {
        $output = { article => {} };  
    }
    $sth->finish; 
} else {
    $output = { article => {} };
}

my $xml = XML::Simple->new();
print $xml->XMLout($output, RootName => undef);

$dbh->disconnect;
