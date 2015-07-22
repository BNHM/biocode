#!/usr/bin/perl
# biocode_report_accumulations
require "/usr/local/web/biocode/cgi/myquery_utils.p";
require "/usr/local/web/biocode/cgi/biocode_settings";

# need to put this here because wierdness in includes
@TaxTeams = qw (ALGAE FUNGI PLANTS MINV OUTREACH POC MVERTS TINV TVERTS ALL);

my $database = "biocode_reporting";
$dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_fulluser","$g_db_fullpass");

# Prepare Tables
$q= "DROP TABLE IF EXISTS species_per_event_accumulation";
$sth = $dbh->prepare( $q) or print "database inaccessible. $DBI::errstr\n";
$sth->execute or print "Error executing query: $query\n";

$q = "CREATE TABLE species_per_event_accumulation (taxteam varchar(40),eventid int, count int)";
$sth = $dbh->prepare( $q) or print "database inaccessible. $DBI::errstr\n";
$sth->execute or print "Error executing query: $query\n";

$q = "DROP TABLE IF EXISTS species_per_date_accumulation";
$sth = $dbh->prepare( $q) or print "database inaccessible. $DBI::errstr\n";
$sth->execute or print "Error executing query: $query\n";

$q = "CREATE TABLE species_per_date_accumulation (taxteam varchar(40),date_collected varchar(40), count int)";
$sth = $dbh->prepare( $q) or print "database inaccessible. $DBI::errstr\n";
$sth->execute or print "Error executing query: $query\n";

# Run each insert statement
foreach $tt (@TaxTeams) {
	$insert = &run_species_per_event_accumulation($tt);
	if ($insert ne "") {
		print $insert;
		$dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_fulluser","$g_db_fullpass");
		if ( !defined $dbh ) { print "database inaccessible. $DBI::errstr\n"; }
	    	$sth = $dbh->prepare( $insert) or print "database inaccessible. $DBI::errstr\n";
		$sth->execute or print "Error executing query: $query\n";
    	$sth->finish;
    	$dbh->disconnect;
	}
}

foreach $tt (@TaxTeams) {
	$insert = &run_species_per_date_accumulation($tt);
	if ($insert ne "") {
		print $insert;
		$dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_fulluser","$g_db_fullpass");
		if ( !defined $dbh ) { print "database inaccessible. $DBI::errstr\n"; }
	    	$sth = $dbh->prepare( $insert) or print "database inaccessible. $DBI::errstr\n";
		$sth->execute or print "Error executing query: $query\n";
    	$sth->finish;
    	$dbh->disconnect;
	}
}

sub run_species_per_date_accumulation($taxteam) {
    my ($taxteam) = @_;
    my $query = "";
    my @all_dates_collected = ();
    my @row = ();
    my $database = "biocode_reporting";
    my $dates = "ifnull(e.yearcollected,0), ifnull(e.monthcollected,0), ifnull(e.daycollected,0)";
    my $count = 0;
    my $strJson="";
    my $fieldnum = 0;

    ### get all the events per taxteam, in chronological order
    $query  = "select concat_ws('-'," . $dates. ") as date from biocode_collecting_event as e  ";
    if($taxteam ne "ALL") {
        $query .= "where e.taxteam = '$taxteam' ";
    }
    $query .= "group by $dates order by $dates";

    $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_fulluser","$g_db_fullpass");
    if ( !defined $dbh ) { return "database inaccessible. $DBI::errstr\n"; }
        $sth = $dbh->prepare( $query ) or return "database inaccessible. $DBI::errstr\n";
    $sth->execute or return "Error executing query: $query\n";

    foreach $clear (@row) { $clear = ""; }    # clear out array

    while ( @row = $sth->fetchrow ) {
        foreach my $date_collected (@row) {
            chomp($date_collected);
            push(@all_dates_collected,$date_collected);
        }
    }


    ### lookup the unique species per event
    ### make array of unique species as we go along
    ### increment count if species is already in the array

	$insert = "";
    foreach my $date_collected (@all_dates_collected) {
        my ($y,$m,$d) = split(/\-/,$date_collected);
        $query  = "select lowesttaxon_generated ";
        $query .= "from biocode as b, biocode_collecting_event as e ";
        $query .= "where e.yearcollected = $y ";
        $query .= "and e.monthcollected = $m ";
        $query .= "and e.daycollected = $d ";
        $query .= "and e.eventid = b.coll_eventid ";
        $query .= "and b.bnhm_id like 'mbio%' ";
        $query .= "group by b.lowesttaxon_generated order by b.lowesttaxon_generated ";

        $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_fulluser","$g_db_fullpass");
        if ( !defined $dbh ) { return "database inaccessible. $DBI::errstr\n"; }
            $sth = $dbh->prepare( $query ) or return "database inaccessible. $DBI::errstr\n";
        $sth->execute or return "Error executing query: $query\n";

        foreach $clear (@row) { $clear = ""; }    # clear out array

        while ( @row = $sth->fetchrow ) {
            foreach my $lowesttaxon_generated (@row) {
                chomp($lowesttaxon_generated);
                if ( grep( /^$lowesttaxon_generated$/,@all_taxa ) ) {
                   # print "MATCHED: $eventid: $lowesttaxon_generated<br>\n";
                } else {
                   $count++;
                   push(@all_taxa,$lowesttaxon_generated);
                }
            }
        }

        $fieldnum = 0;

		# insert each taxteam separately into this table
		$insert.="(\"$taxteam\",\"$date_collected\",\"$count\"),";
    }

 	chop($insert); # remove last ,

	if ($insert ne "") {
		$insert = "INSERT INTO species_per_date_accumulation VALUES ".$insert;
	}

    $sth->finish;
    $dbh->disconnect;
	return $insert;
}

sub run_species_per_event_accumulation {
    my ($taxteam) = @_;
    my $query = "";
    my @all_events = ();
    my @row = ();
    my $database = "biocode_reporting";
    my $dates = "ifnull(e.yearcollected,0), ifnull(e.monthcollected,0), ifnull(e.daycollected,0)";
    my $count = 0;

    ### get all the events per taxteam, in chronological order
    $query  = "select e.eventid from biocode_collecting_event as e ";
	if ($taxteam ne 'ALL') {
    	$query .= "where e.taxteam = '$taxteam' ";
	}
    $query .= "order by $dates";

    $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_fulluser","$g_db_fullpass");
    if ( !defined $dbh ) { return "database inaccessible. $DBI::errstr\n"; }
    $sth = $dbh->prepare( $query ) or return "database inaccessible. $DBI::errstr\n";
    $sth->execute or return "Error executing query: $query\n";

    foreach $clear (@row) { $clear = ""; }    # clear out array

    while ( @row = $sth->fetchrow ) {
        foreach my $eventid (@row) {
            chomp($eventid);
            push(@all_events,$eventid);
        }
    }

    ### lookup the unique species per event
    ### make array of unique species as we go along
    ### increment count if species is already in the array

	$insert = "";
    foreach my $eventid (@all_events) {
        $query  = "select lowesttaxon_generated ";
        $query .= "from biocode ";
        $query .= "where coll_eventid = '$eventid' ";
        $query .= "and bnhm_id like 'mbio%' ";
        $query .= "group by lowesttaxon_generated order by lowesttaxon_generated ";

        $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_fulluser","$g_db_fullpass");
        if ( !defined $dbh ) { return "database inaccessible. $DBI::errstr\n"; }
            $sth = $dbh->prepare( $query ) or return "database inaccessible. $DBI::errstr\n";
        $sth->execute or return "Error executing query: $query\n";

        foreach $clear (@row) { $clear = ""; }    # clear out array

        while ( @row = $sth->fetchrow ) {
            foreach my $lowesttaxon_generated (@row) {
                chomp($lowesttaxon_generated);
                if ( grep( /^$lowesttaxon_generated$/,@all_taxa ) ) {
                   # print "MATCHED: $eventid: $lowesttaxon_generated<br>\n";
                } else {
                   $count++;
                   push(@all_taxa,$lowesttaxon_generated);
                }
            }
        }

		# insert each taxteam separately into this table
		$insert.="(\"$taxteam\",\"$eventid\",\"$count\"),";
    }
	if ($insert ne "") {
		$insert = "INSERT INTO species_per_event_accumulation VALUES ".$insert;
	}

 	chop($insert); # remove last ,

    $sth->finish;
    $dbh->disconnect;
	return $insert;
}
