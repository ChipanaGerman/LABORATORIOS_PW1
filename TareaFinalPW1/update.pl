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

my ($title, $text, $owner) = (param('title'), param('text'), param('owner'));

my $sth_check = $dbh->prepare("SELECT COUNT(*) FROM Articles WHERE title=? AND owner=?");
$sth_check->execute($title, $owner);
my ($count) = $sth_check->fetchrow_array();
$sth_check->finish;

my $output;

if ($count > 0) {
    my $sth_update = $dbh->prepare("UPDATE Articles SET text=? WHERE title=? AND owner=?");
    
    if ($sth_update->execute($text, $title, $owner)) {
        $output = { article => { title => $title, text => $text } };
    } else {
        $output = { article => {} }; 
    }
    $sth_update->finish;
} else {
    $output = { article => {} };
}

my $xml = XML::Simple->new();
print $xml->XMLout($output, RootName => undef);

$dbh->disconnect;
