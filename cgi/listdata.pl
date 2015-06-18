#!/usr/bin/perl -w
require("utils.p");
use DBI;

$dbh = DBI->connect( "dbi:SQLite:../pictures/data.dbl" ) || die "Cannot connect: $DBI::errstr";

#my $res=$dbh->selectall_arrayref("SELECT * from photomatch");
my $res=$dbh->selectall_arrayref("SELECT internalid FROM photomatch WHERE specimenNumCollector='1' AND enteredby='JBD' AND picture='http://localhost/pictures/gustav/dFL_00225.jpg'");

#print $res->[0][0];
foreach( @$res ) {
	foreach $i (0..$#$_) { 
		print "$_->[$i]|"
	}
    print "\n";
}

$dbh->disconnect;
