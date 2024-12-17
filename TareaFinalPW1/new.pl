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

my ($title, $text, $owner) = (scalar param('title'), scalar param('text'), scalar param('owner'));

my $xml = XML::Simple->new();
my $output;

my $sth_check = $dbh->prepare("SELECT COUNT(*) FROM Users WHERE userName = ?");
$sth_check->execute($owner);
my ($exists) = $sth_check->fetchrow_array();

if (!$exists) {
    $output = { article => { title => "", text => "" } };
    print $xml->XMLout($output, RootName => undef);
    $sth_check->finish;
    $dbh->disconnect;
    exit;
}
$sth_check->finish;

my $sth = $dbh->prepare("INSERT INTO Articles (title, text, owner) VALUES (?, ?, ?)");
if ($sth->execute($title, $text, $owner)) {
    $output = { article => { title => $title, text => $text } };
} else {
    $output = { article => { title => "", text => "" } };
}

print $xml->XMLout($output, RootName => undef);

$sth->finish;
$dbh->disconnect;