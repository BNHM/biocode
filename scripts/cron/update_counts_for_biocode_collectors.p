#!/usr/bin/perl

# update_counts_for_biocode_collectors.p  GO 3/25/04
# 
# updated 10/19/04 to get count from biocode:collector_list

# This runs on cron, updates the counts for all biocode collectors

# $DEBUG = 1;

require "/usr/local/web/biocode/cgi/myquery_utils.p";
require "/usr/local/web/biocode/cgi/utils.p";

$script_name = "biocode_query";

##########
# step one: make a list of biocode_collectors
##########

# 5/2008: changed "where collector=1" to "where collector > 0"
if ($DEBUG) {
    $query1 = "select name_full from biocode_people where collector > 0 and name_full like \"G%\"";
} else {
    $query1 = "select name_full from biocode_people where collector > 0";
}
$tmp = &get_multiple_records($query1,"biocode");
open(FH, "$tmp") || die "Can't open $tmp for reading";

while($line = <FH>) {
    chomp($line);
    $coll_name = $line;
    $coll_name =~ s/\'/\\\'/;   # backslash for single quote
    if ($DEBUG) {
	print "Name: $coll_name\n";
    }
    # $query2 = "select count(*) from biocode_collecting_event where Collector_list like \"%$coll_name%\"";

    $query2  = "select count(*) from biocode as b, biocode_collecting_event as e ";
    $query2 .= "where b.coll_eventid = e.eventid and e.Collector_list like '%$coll_name%'";

    if ($DEBUG) {
        print "\tQuery2: $query2\n";
    }
    ##########
    # step two: get count from biocode and update biocode_people
    ##########
    @count_row = &get_one_record($query2,"biocode");
    $num_specs = $count_row[0];
    if ($DEBUG) {
        print "\tNum: $num_specs\n";
    }
    if ($coll_name && $num_specs) {
	$update = "update biocode_people set num_specimens = $num_specs where name_full='$coll_name';";
	if ($DEBUG) {
	    print "$update\n";
	} else {
	    &process_query($update, "biocode");
	}
    } elsif ($coll_name) {
	$update = "update biocode_people set num_specimens = null where name_full='$coll_name';";
	&process_query($update, "biocode");
	# print "Didn't find specimens for $coll_name\n";
    }
}
close(FH);
