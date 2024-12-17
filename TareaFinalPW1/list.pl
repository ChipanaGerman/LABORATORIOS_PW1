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

my $owner = param('owner');

my $sth = $dbh->prepare("SELECT owner, title FROM Articles WHERE owner=?");
$sth->execute($owner);

my @articles;
while (my $ref = $sth->fetchrow_hashref) {
    push @articles, { article => { owner => $ref->{owner}, title => $ref->{title} } };
}

my $xml = XML::Simple->new();
print $xml->XMLout({ articles => \@articles }, RootName => 'articles');  

$sth->finish;
$dbh->disconnect;

