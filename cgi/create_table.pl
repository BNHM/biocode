#!/usr/bin/perl
use DBI;

$dbh = DBI->connect( "dbi:SQLite:../pictures/data.dbl" ) || die "Cannot connect: $DBI::errstr";
$dbh->func( 'now', 0, sub { return time }, 'create_function' );
#$dbh->do( "DROP TABLE photomatch" );
$dbh->do( "CREATE TABLE photomatch( internalid INTEGER PRIMARY KEY,specimenNumCollector,enteredby,picture,directory)" );
$dbh->disconnect;
