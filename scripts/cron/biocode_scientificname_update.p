#!/usr/bin/perl

use strict;


require "/usr/local/web/biocode/cgi/biocode_settings";
require "/usr/local/web/cgi/utils.p";
require "/usr/local/web/cgi/myquery_utils.p"; 


my $select = "";

$select = "select Genus, SpecificEpithet, SubspecificEpithet, bnhm_id ";
$select .= "from biocode";


my $tmp = &get_multiple_records("$select","biocode");

open(FH,"$tmp");
open(OH,">/usr/local/web/test/biocode/scripts/cron/out");






while (<FH>) {
    my $line = $_;
    chomp($line);

    my $ScientificName = "";

    my ($Genus, $SpecificEpithet, $SubspecificEpithet, $bnhm_id) = split(/\t/,$line);

    $ScientificName = "$Genus $SpecificEpithet $SubspecificEpithet";
    $ScientificName = &strip($ScientificName);


    if($bnhm_id) {

        $ScientificName =~ s/'/\\'/g;

        my $update  = "update biocode set ";
        $update    .= "ScientificName = '$ScientificName' ";
        $update    .= "where bnhm_id = '$bnhm_id'";

        # print OH "$update;\n";
        &process_query($update,"biocode");
    }



}

 close(FH);
 close(OH);
